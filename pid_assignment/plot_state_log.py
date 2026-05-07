#!/usr/bin/env python3
"""
Plot ROS2 JointControllerState logs stored as a YAML stream (--- separated).

Example:
  python3 pid_assignment/plot_state_log.py pid_assignment/state_log.txt --show
  python3 pid_assignment/plot_state_log.py pid_assignment/state_log.txt --out state.png
  python3 pid_assignment/plot_state_log.py pid_assignment/state_log.txt other_log.txt --out overlay.png
"""

from __future__ import annotations

import argparse
import os
from dataclasses import dataclass
from typing import Any, Dict, Iterable, List, Optional, Sequence, Tuple


def _require(module_name: str, pip_name: Optional[str] = None):
    try:
        return __import__(module_name)
    except Exception as e:  # pragma: no cover
        hint = pip_name or module_name
        raise SystemExit(
            f"Missing dependency '{module_name}'. Install it with:\n"
            f"  python3 -m pip install {hint}\n\n"
            f"Original error: {e}"
        )


yaml = _require("yaml", "pyyaml")
plt = _require("matplotlib.pyplot", "matplotlib").pyplot  # type: ignore[attr-defined]
mpl_ticker = _require("matplotlib.ticker", "matplotlib").ticker  # type: ignore[attr-defined]


def _split_yaml_stream(text: str) -> List[str]:
    # Logs are typically a YAML stream with docs separated by "---".
    # We split on lines that are exactly '---' (optionally surrounded by whitespace).
    blocks: List[str] = []
    cur: List[str] = []
    for line in text.splitlines():
        if line.strip() == "---":
            block = "\n".join(cur).strip()
            if block:
                blocks.append(block)
            cur = []
        else:
            cur.append(line)
    tail = "\n".join(cur).strip()
    if tail:
        blocks.append(tail)
    return blocks


def load_state_log(path: str) -> List[Dict[str, Any]]:
    with open(path, "r", encoding="utf-8") as f:
        text = f.read()

    # Try fast path: yaml.safe_load_all (works if file is a proper YAML stream).
    # If that fails, fall back to manual splitting.
    try:
        docs = list(yaml.safe_load_all(text))
        out = [d for d in docs if isinstance(d, dict)]
        if out:
            return out
    except Exception:
        pass

    out: List[Dict[str, Any]] = []
    for block in _split_yaml_stream(text):
        try:
            d = yaml.safe_load(block)
        except Exception:
            continue
        if isinstance(d, dict):
            out.append(d)
    return out


def _get_nested(d: Dict[str, Any], keys: Sequence[str]) -> Any:
    cur: Any = d
    for k in keys:
        if not isinstance(cur, dict) or k not in cur:
            return None
        cur = cur[k]
    return cur


def _to_float(x: Any) -> Optional[float]:
    if x is None:
        return None
    if isinstance(x, (int, float)):
        return float(x)
    try:
        return float(str(x))
    except Exception:
        return None


def _format_const_summary(
    docs: List[Dict[str, Any]], keys: Sequence[str]
) -> Tuple[str, Dict[str, Tuple[Optional[float], Optional[float]]]]:
    """
    Returns (summary_string, per_key_minmax).
    If a key is missing everywhere, it's omitted from the string.
    """
    per_key_values: Dict[str, List[Optional[float]]] = {k: [] for k in keys}
    for d in docs:
        for k in keys:
            v = d.get(k)
            if isinstance(v, bool):
                # keep bools as 0/1? better: treat separately by string
                continue
            per_key_values[k].append(_to_float(v))

    per_key_minmax: Dict[str, Tuple[Optional[float], Optional[float]]] = {}
    parts: List[str] = []
    for k in keys:
        vs = [v for v in per_key_values.get(k, []) if v is not None]
        if not vs:
            continue
        vmin = min(vs)
        vmax = max(vs)
        per_key_minmax[k] = (vmin, vmax)
        if abs(vmax - vmin) < 1e-12:
            parts.append(f"{k}={vmin:.2f}")
        else:
            parts.append(f"{k}∈[{vmin:.2f},{vmax:.2f}]")

    # handle bool-ish keys we care about (antiwindup)
    if "antiwindup" in keys:
        vals = [d.get("antiwindup") for d in docs if "antiwindup" in d]
        if vals:
            uniq = sorted({str(v).lower() for v in vals})
            if len(uniq) == 1:
                parts.append(f"antiwindup={uniq[0]}")
            else:
                parts.append(f"antiwindup∈{{{', '.join(uniq)}}}")

    return ("  ".join(parts), per_key_minmax)


@dataclass
class Series:
    label: str
    t: List[float]
    values: Dict[str, List[Optional[float]]]


def extract_series(
    docs: List[Dict[str, Any]], *, label: str, fields: Sequence[str]
) -> Series:
    t_abs: List[float] = []
    values: Dict[str, List[Optional[float]]] = {f: [] for f in fields}

    for d in docs:
        sec = _get_nested(d, ["header", "stamp", "sec"])
        nsec = _get_nested(d, ["header", "stamp", "nanosec"])
        ts = _to_float(sec)
        tns = _to_float(nsec)
        if ts is None or tns is None:
            continue
        t_abs.append(ts + tns * 1e-9)

        for f in fields:
            values[f].append(_to_float(d.get(f)))

    if not t_abs:
        return Series(label=label, t=[], values=values)

    t0 = t_abs[0]
    t = [x - t0 for x in t_abs]
    return Series(label=label, t=t, values=values)


def _plot_default_layout(series_list: Sequence[Series], title: str):
    fig, axes = plt.subplots(2, 1, sharex=True, figsize=(10, 7))
    ax0, ax1 = axes

    for s in series_list:
        t = s.t
        sp = s.values.get("set_point", [])
        pv = s.values.get("process_value", [])
        err = s.values.get("error", [])

        if sp:
            ax0.plot(t, sp, label=f"{s.label}: set_point", linewidth=1.5)
        if pv:
            ax0.plot(t, pv, label=f"{s.label}: process_value", linewidth=1.5)
        if err:
            ax1.plot(t, err, label=f"{s.label}: error", linewidth=1.2)

    ax0.set_ylabel("position")
    ax1.set_ylabel("error")
    ax1.set_xlabel("time [s]")
    fig.suptitle(title)

    for ax in axes:
        ax.grid(True, which="major", alpha=0.35)
        ax.grid(True, which="minor", alpha=0.18)
        ax.legend(loc="best", fontsize=9)

    fig.tight_layout()
    return fig


def _plot_fields_layout(series_list: Sequence[Series], title: str, fields: Sequence[str]):
    fig, ax = plt.subplots(1, 1, figsize=(10, 5))
    for s in series_list:
        for f in fields:
            ys = s.values.get(f, [])
            if ys:
                ax.plot(s.t, ys, label=f"{s.label}: {f}", linewidth=1.3)

    ax.set_xlabel("time [s]")
    ax.set_ylabel("value")
    ax.set_title(title)
    ax.grid(True, which="major", alpha=0.35)
    ax.grid(True, which="minor", alpha=0.18)
    ax.legend(loc="best", fontsize=9)
    fig.tight_layout()
    return fig


def _plot_overlay_layout(series_list: Sequence[Series], title: str, fields: Sequence[str]):
    # Single axis overlay. In this assignment logs, position and error are often comparable.
    fig, ax = plt.subplots(1, 1, figsize=(10, 5))
    for s in series_list:
        for f in fields:
            ys = s.values.get(f, [])
            if ys:
                style = {}
                if f == "error":
                    style = {"linestyle": "--", "alpha": 0.9}
                lw = 1.2 if f == "error" else 1.3
                ax.plot(s.t, ys, label=f"{s.label}: {f}", linewidth=lw, **style)

    ax.set_xlabel("time [s]")
    ax.set_ylabel("value")
    ax.set_title(title)
    ax.grid(True, which="major", alpha=0.35)
    ax.grid(True, which="minor", alpha=0.18)
    ax.legend(loc="best", fontsize=9, ncols=1)
    fig.tight_layout()
    return fig


def _apply_time_markers(
    axes: Sequence[Any], *, major_s: float, minor_s: float
) -> None:
    if major_s > 0:
        locator = mpl_ticker.MultipleLocator(major_s)
        for ax in axes:
            ax.xaxis.set_major_locator(locator)
    if minor_s > 0:
        locator = mpl_ticker.MultipleLocator(minor_s)
        for ax in axes:
            ax.xaxis.set_minor_locator(locator)


def _annotate_constants(fig: Any, text: str) -> None:
    if not text:
        return
    fig.text(
        0.99,
        0.01,
        text,
        ha="right",
        va="bottom",
        fontsize=9,
        family="monospace",
        bbox=dict(boxstyle="round,pad=0.35", facecolor="white", alpha=0.75, edgecolor="0.75"),
    )


def main(argv: Optional[Sequence[str]] = None) -> int:
    p = argparse.ArgumentParser(
        description="Plot YAML-stream JointControllerState logs (--- separated)."
    )
    p.add_argument("logs", nargs="+", help="Path(s) to log file(s)")
    p.add_argument(
        "--fields",
        default="set_point,process_value,error",
        help="Comma-separated fields to plot (default: set_point,process_value,error)",
    )
    p.add_argument("--title", default="", help="Plot title (default: derived from filename)")
    p.add_argument("--out", default="", help="Save plot to this path (e.g. plot.png)")
    p.add_argument(
        "--tmajor",
        type=float,
        default=1.0,
        help="Major vertical time marker spacing in seconds (default: 1.0, set 0 to disable)",
    )
    p.add_argument(
        "--tminor",
        type=float,
        default=0.2,
        help="Minor vertical time marker spacing in seconds (default: 0.2, set 0 to disable)",
    )
    p.add_argument(
        "--show",
        action="store_true",
        help="Show interactive window (useful locally; on headless machines use --out)",
    )
    p.add_argument(
        "--show-constants",
        action="store_true",
        help="Annotate plot with controller constants (p,i,d,i_clamp,antiwindup)",
    )
    p.add_argument(
        "--layout",
        choices=["stacked", "overlay"],
        default="overlay",
        help="Plot layout: overlay (single panel) or stacked (2 panels for default fields). Default: overlay",
    )

    args = p.parse_args(argv)
    fields = [f.strip() for f in args.fields.split(",") if f.strip()]
    if not fields:
        raise SystemExit("No fields selected. Use --fields a,b,c")

    series_list: List[Series] = []
    docs_by_log: List[List[Dict[str, Any]]] = []
    for log_path in args.logs:
        docs = load_state_log(log_path)
        docs_by_log.append(docs)
        label = os.path.basename(log_path)
        series_list.append(extract_series(docs, label=label, fields=fields))

    if not series_list or all(len(s.t) == 0 for s in series_list):
        raise SystemExit("No valid samples found in provided log(s).")

    title = args.title.strip() or " | ".join(os.path.basename(p) for p in args.logs)

    default_fields = {"set_point", "process_value", "error"}
    if args.layout == "overlay":
        fig = _plot_overlay_layout(series_list, title=title, fields=fields)
        _apply_time_markers(fig.axes, major_s=args.tmajor, minor_s=args.tminor)
    else:
        if set(fields) == default_fields:
            fig = _plot_default_layout(series_list, title=title)
            _apply_time_markers(fig.axes, major_s=args.tmajor, minor_s=args.tminor)
        else:
            fig = _plot_fields_layout(series_list, title=title, fields=fields)
            _apply_time_markers(fig.axes, major_s=args.tmajor, minor_s=args.tminor)

    if args.show_constants:
        const_lines: List[str] = []
        for log_path, docs in zip(args.logs, docs_by_log):
            summary, _ = _format_const_summary(docs, keys=["p", "i", "d", "i_clamp", "antiwindup"])
            if summary:
                const_lines.append(f"{os.path.basename(log_path)}: {summary}")
        if const_lines:
            _annotate_constants(fig, "\n".join(const_lines))

    if args.out:
        fig.savefig(args.out, dpi=150)
        print(f"Saved: {args.out}")

    if args.show:
        plt.show()
    elif not args.out:
        print("Nothing to do: pass --show and/or --out plot.png")

    return 0


if __name__ == "__main__":
    raise SystemExit(main())

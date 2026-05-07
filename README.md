# IN4140 — Assignment 4 (PID controller)

Notes for running the simulator + bridge + PID controller stack on the IFI RHEL clients.

> Run everything from the **VMware/RHEL graphical session** (not over plain SSH) so that the Gazebo and rqt windows can use OpenGL. Open three terminals.

## One-time terminal setup (VMware desktop only)

The `in3140_ros*` aliases live in `/etc/profile.d/in3140_ros.sh`, which is only loaded by login shells. GNOME Terminal opens non-login shells by default, so add this once:

```bash
echo 'source /etc/profile.d/in3140_ros.sh' >> ~/.bashrc
```

Open new terminals after this (or `source ~/.bashrc`). The IDE's terminal already loads it.

## Order matters

Always start the terminals in this order — each one depends on the previous:

1. **Terminal #1** — ROS1 simulator (Gazebo)
2. **Terminal #2** — ROS1 ↔ ROS2 bridge
3. **Terminal #3** — ROS2 PID controller (rqt)

When shutting down, `Ctrl+C` in the **reverse** order: #3 → #2 → #1.

---

## Terminal #1 — ROS1 simulator

### First time only (clone simulator workspace)

```bash
in3140_ros1
mkdir -p ~/in4140/crust_crawler_simulator/src
cd ~/in4140/crust_crawler_simulator/src
git clone git@github.uio.no:IN3140/crustcrawler_simulation.git
git clone git@github.uio.no:IN3140/crustcrawler_pen.git
cd ..
source /opt/ros/noetic/setup.bash
catkin_make
source devel/setup.bash
roslaunch crustcrawler_pen_gazebo controller.launch
```

> The `git clone` commands need an SSH key registered with `github.uio.no`. If HTTPS fails with "Anonymous access denied", that's why — switch to the SSH URLs above.

### Every time after that

```bash
in3140_ros1
cd ~/in4140/crust_crawler_simulator
source /opt/ros/noetic/setup.bash
source devel/setup.bash
roslaunch crustcrawler_pen_gazebo controller.launch
```

Wait until you see this line before moving on:

```
Started controllers: joint_state_controller, joint1_controller, joint2_controller, joint3_controller
```

If `gazebo_gui` segfaults with `libGL` errors, the physics simulation is still running — you can ignore it, or relaunch with `gui:=false`:

```bash
roslaunch crustcrawler_pen_gazebo controller.launch gui:=false
```

---

## Terminal #2 — ROS1 ↔ ROS2 bridge

```bash
in3140_ros_bridge
source /opt/ros/foxy/setup.bash
source install/setup.bash          # ROS_distro warnings are normal
source /opt/ros/noetic/setup.bash  # ROS_distro warnings are normal
rosparam load bridge.yaml
ros2 run ros1_bridge parameter_bridge
```

Leave it running. The container drops you into a directory that already contains `bridge.yaml`, so no `cd` needed.

A bunch of `failed to create bidirectional bridge ... No template specialization for the pair` lines are normal — those topics use message types the bridge doesn't have a hardcoded mapping for. The topics you need (`/crustcrawler/joint_states`, `/crustcrawler/joint2_controller/command`, `/clock`, `/tf`, `/tf_static`) all bridge successfully.

---

## Terminal #3 — ROS2 PID controller

### First time (and after editing `setup.py`, launch files, or message types)

```bash
in3140_ros2
cd ~/in4140/pid_assignment
source /opt/ros/humble/setup.bash
colcon build --symlink-install
source install/setup.bash
ros2 launch pid_assignment pid.launch.py
```

### Every time after that

With `--symlink-install`, edits to `pid.py` / `node.py` are picked up automatically — just relaunch:

```bash
in3140_ros2
cd ~/in4140/pid_assignment
source /opt/ros/humble/setup.bash
source install/setup.bash
ros2 launch pid_assignment pid.launch.py
```

This opens an rqt window with the perspective from `pid_assignment/launch/crustcrawler.perspective`. Use the sliders to set `p`, `i`, `d`, `c` for tuning.

---

## Common gotchas

- **`catkin_make: source space ... does not exist`** — you're not in the workspace root. `cd ~/in4140/crust_crawler_simulator` first.
- **`rqt` sliders do nothing** — bridge isn't running, or terminal #1 didn't finish loading controllers.
- **`ros2 launch` says package `pid_assignment` not found** — you forgot `source install/setup.bash` after `colcon build`.
- **`libGL: No matching fbConfigs / failed to load driver: swrast`** — OpenGL backend can't initialize. Only matters for Gazebo's 3D viewer; the simulator and rqt plots still work. Use the VMware graphical session to avoid it.
- **`Permission denied (publickey)` on `git clone`** — your SSH key isn't registered at `github.uio.no`. Add `~/.ssh/id_ed25519.pub` to your account there.


 ps [options]

 Try 'ps --help <simple|list|output|threads|misc|all>'
  or 'ps --help <s|l|o|t|m|a>'
 for additional help text.

For more details see ps(1).
[johnrav@ic-ifi-l-006 ~]$ ps -p $$ -o comm=
bash
[johnrav@ic-ifi-l-006 ~]$ bash -lc 'type in3140_ros1 || echo "bash login shell: not found'
/uio/hume/student-u88/johnrav/.bash_login: line 10: /local/lib/setupfiles/bash_login: No such file or directory
bash: -c: line 1: unexpected EOF while looking for matching `"'
bash: -c: line 2: syntax error: unexpected end of file
[johnrav@ic-ifi-l-006 ~]$ ls -l /etc/profile.d/in3140_ros.sh || echo "missing thing"
-rw-r--r--. 1 root root 225 Apr 29 09:41 /etc/profile.d/in3140_ros.sh
[johnrav@ic-ifi-l-006 ~]$ ^C
[johnrav@ic-ifi-l-006 ~]$ 




alias in3140_ros1='apptainer shell --env LANG=C --env '\''PS1=\u@in3140-ros1 \W> '\'' --env LC_ALL=C /opt/ifi/in3140/in3140_ros1.sif'
alias in3140_ros2='apptainer shell --bind /run/user/:/run/user/ --env LANG=C --env '\''PS1=\u@in3140-ros2 \W> '\'' --env LC_ALL=C /opt/ifi/in3140/in3140_ros2.sif'
alias in3140_ros_bridge='cd /opt/ifi/in3140/ros_bridge/ || return; apptainer shell --env '\''PS1=\u@in3140-bridge \W> '\'' --env LANG=C --env LC_ALL=C --bind /opt/ifi/in3140/ros_bridge/:/opt/ifi/in3140/ros_bridge/ /opt/ifi/in3140/in3140_ros1.sif'

command -v innetgr || echo "innetgr missing"
innetgr -u "$USER" ifi-robin; echo "innetgr exit=$?"


[johnrav@ic-ifi-l-006 ~]$ command -v innetgr || echo "innetgr missing"
/usr/bin/innetgr
[johnrav@ic-ifi-l-006 ~]$ innetgr -u "$USER" ifi-robin; echo "innetgr exit=$?"
innetgr exit=0
[johnrav@ic-ifi-l-006 ~]$ 


echo "0=$0  SHELL=$SHELL"
shopt -q login_shell; echo "login_shell=$?"
type in3140_ros1 || echo "in3140_ros1: not defined"
grep -n "in3140_ros" ~/.bashrc || echo "~/.bashrc has no in3140_ros"

source /etc/profile.d/in3140_ros.sh
type in3140_ros1


[johnrav@ic-ifi-l-006 ~]$ in3140_ros1
bash: in3140_ros1: command not found...
[johnrav@ic-ifi-l-006 ~]$ echo "0=$0  SHELL=$SHELL"
0=bash  SHELL=/bin/bash
[johnrav@ic-ifi-l-006 ~]$ shopt -q login_shell; echo "login_shell=$?"
login_shell=1
[johnrav@ic-ifi-l-006 ~]$ type in3140_ros1 || echo "in3140_ros1: not defined"
bash: type: in3140_ros1: not found
in3140_ros1: not defined
[johnrav@ic-ifi-l-006 ~]$ grep -n "in3140_ros" ~/.bashrc || echo "~/.bashrc has no in3140_ros"
12:source /etc/profile.d/in3140_ros.sh
13:source /etc/profile.d/in3140_ros.sh
[johnrav@ic-ifi-l-006 ~]$ 


[johnrav@ic-ifi-l-006 ~]$ source /etc/profile.d/in3140_ros.sh
[johnrav@ic-ifi-l-006 ~]$ type in3140_ros1
bash: type: in3140_ros1: not found
[johnrav@ic-ifi-l-006 ~]$ 

echo "USER=[$USER]"
innetgr -u $USER ifi-robin; echo "exit=$?"

[johnrav@ic-ifi-l-006 ~]$ echo "USER=[$USER]"
USER=[johnrav]
[johnrav@ic-ifi-l-006 ~]$ innetgr -u $USER ifi-robin; echo "exit=$?"
exit=0
[johnrav@ic-ifi-l-006 ~]$ 


alias in3140_ros1='apptainer shell --env LANG=C --env '\''PS1=\u@in3140-ros1 \W> '\'' --env LC_ALL=C /opt/ifi/in3140/in3140_ros1.sif'
alias in3140_ros2='apptainer shell --bind /run/user/:/run/user/ --env LANG=C --env '\''PS1=\u@in3140-ros2 \W> '\'' --env LC_ALL=C /opt/ifi/in3140/in3140_ros2.sif'
alias in3140_ros_bridge='cd /opt/ifi/in3140/ros_bridge/ || return; apptainer shell --env '\''PS1=\u@in3140-bridge \W> '\'' --env LANG=C --env LC_ALL=C --bind /opt/ifi/in3140/ros_bridge/:/opt/ifi/in3140/ros_bridge/ /opt/ifi/in3140/in3140_ros1.sif'

source ~/.bashrc
type in3140_ros1
in3140_ros1

source /etc/profile.d/in3140_ros.sh
alias | grep in3140 || echo "no in3140 aliases"


[johnrav@ic-ifi-l-006 ~]$ source /etc/profile.d/in3140_ros.sh
[johnrav@ic-ifi-l-006 ~]$ alias | grep in3140 || echo "no in3140 aliases"
alias in3140_ros='apptainer shell --env '\''PS1=\u@in3140 \W> '\'' /opt/ifi/in3140/in3140_ros.sif'
[johnrav@ic-ifi-l-006 ~]$ ^C


cat >> ~/.bashrc <<'EOF'

# IN3140 helper aliases (VMware fallback)
alias in3140_ros1='apptainer shell --env LANG=C --env '\''PS1=\u@in3140-ros1 \W> '\'' --env LC_ALL=C /opt/ifi/in3140/in3140_ros1.sif'
alias in3140_ros2='apptainer shell --bind /run/user/:/run/user/ --env LANG=C --env '\''PS1=\u@in3140-ros2 \W> '\'' --env LC_ALL=C /opt/ifi/in3140/in3140_ros2.sif'
alias in3140_ros_bridge='cd /opt/ifi/in3140/ros_bridge/ || return; apptainer shell --env '\''PS1=\u@in3140-bridge \W> '\'' --env LANG=C --env LC_ALL=C --bind /opt/ifi/in3140/ros_bridge/:/opt/ifi/in3140/ros_bridge/ /opt/ifi/in3140/in3140_ros1.sif'
EOF

source ~/.bashrc
type in3140_ros1

[johnrav@ic-ifi-l-006 ~]$ in3140_ros1
FATAL:   While checking container encryption: could not open image /opt/ifi/in3140/in3140_ros1.sif: failed to retrieve path for /opt/ifi/in3140/in3140_ros1.sif: lstat /opt/ifi/in3140/in3140_ros1.sif: no such file or directory
[johnrav@ic-ifi-l-006 ~]$ ^C
[johnrav@ic-ifi-l-006 ~]$ 


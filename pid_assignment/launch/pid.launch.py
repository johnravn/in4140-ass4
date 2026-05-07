#!/usr/bin/env python3

from launch import LaunchDescription
from launch.actions import DeclareLaunchArgument
from launch.conditions import IfCondition
from launch.substitutions import LaunchConfiguration
from launch_ros.actions import Node
from ament_index_python.packages import get_package_share_directory
import os

def generate_launch_description():
    show_rqt = LaunchConfiguration('show_rqt')
    perspective_file = os.path.join(
        get_package_share_directory('pid_assignment'),
        'launch',
        'crustcrawler.perspective'
    )

    return LaunchDescription([
        DeclareLaunchArgument(
            'show_rqt',
            default_value='false',
            description='Launch rqt_gui with the PID perspective (requires working OpenGL/X11).',
        ),

        # Launch PID controller node
        Node(
            package='pid_assignment',
            executable='node',  # <-- corrected here
            name='pid_controller',
            output='screen',
        ),

        # Launch RQT with PID perspective
        Node(
            package='rqt_gui',
            executable='rqt_gui',
            name='pid_rqt',
            output='screen',
            arguments=['--perspective-file', perspective_file],
            respawn=False,
            condition=IfCondition(show_rqt),
        ),
    ])

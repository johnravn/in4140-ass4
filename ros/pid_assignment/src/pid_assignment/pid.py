#!/usr/bin/env python3

import rclpy
from rclpy.node import Node
from std_msgs.msg import Float64
from sensor_msgs.msg import JointState
from control_msgs.msg import JointControllerState
import math


class PID:
    """General PID class with P, PD, PID, PIDD options."""

    def __init__(self, logger=None):
        # Proportional constant
        self.p = 0.0

        # Integral constant
        self.i = 0.0

        # Derivative constant
        self.d = 0.0

        # Non-linear constant
        self.c = 0.0

        # Position error
        self.error = 0.0

        # Integral accumulation variable
        self.integral = 0.0

        self._logger = logger

    def __call__(self, desired_theta, current_theta, velocity_theta, dt):
        """
        Perform PID control step

        :param desired_theta: Desired set-point in radians
        :param current_theta: Current joint angle in radians
        :param velocity_theta: Current joint angle velocity in radians/second
        :param dt: Time since last call in seconds
        :returns: Effort for joint
        """

        # TODO: Change which line is commented according to which part
        # you are testing in your code.
        return self.P_ctrl(desired_theta, current_theta, dt)
        # return self.PD_ctrl(desired_theta, current_theta, velocity_theta, dt)
        # return self.PID_ctrl(desired_theta, current_theta, velocity_theta, dt)
        # return self.PIDD_ctrl(desired_theta, current_theta, velocity_theta, dt)

    def P_ctrl(self, desired_theta, current_theta, dt):
        """
        Calculate proportional control

        :param desired_theta: Desired set-point in radians
        :param current_theta: Current joint angle in radians
        :param dt: Time since last call in seconds
        :returns: Effort of joint
        """

        # TODO: Implement!
        return 0.0

    def PD_ctrl(self, desired_theta, current_theta, velocity_theta, dt):
        """
        Calculate Proportional-Derivative control

        :param desired_theta: Desired set-point in radians
        :param current_theta: Current joint angle in radians
        :param velocity_theta: Current joint angle velocity in radians/second
        :param dt: Time since last call in seconds
        :returns: Effort for joint
        """

        # TODO: Implement!
        return 0.0

    def PID_ctrl(self, desired_theta, current_theta, velocity_theta, dt):
        """
        Calculate PID control

        :param desired_theta: Desired set-point in radians
        :param current_theta: Current joint angle in radians
        :param velocity_theta: Current joint angle velocity in radians/second
        :param dt: Time since last call in seconds
        :returns: Effort for joint
        """

        # TODO: Implement!
        return 0.0

    def PIDD_ctrl(self, desired_theta, current_theta, velocity_theta, dt):
        """
        Calculate non-linear PID control

        :param desired_theta: Desired set-point in radians
        :param current_theta: Current joint angle in radians
        :param velocity_theta: Current joint angle velocity in radians/second
        :param dt: Time since last call in seconds
        :returns: Effort for joint
        """

        # TODO: Implement!
        return 0.0


class MultiJointPIDNode(Node):
    def __init__(self, joints=None, mode='P'):
        super().__init__('multi_joint_pid')

        self.joints = joints or [
            'joint1', 'joint2', 'joint3', 'joint4', 'joint5', 'joint6'
        ]

        self.mode = mode

        self.pid_controllers = {j: PID() for j in self.joints}

        self.current_positions = {j: 0.0 for j in self.joints}
        self.current_velocities = {j: 0.0 for j in self.joints}
        self.setpoints = {j: 0.0 for j in self.joints}

        self.publishers = {
            j: self.create_publisher(
                Float64,
                f'/crustcrawler/{j}_controller/command',
                10
            )
            for j in self.joints
        }

        self.state_publishers = {
            j: self.create_publisher(
                JointControllerState,
                f'/pid_controller/{j}_state',
                10
            )
            for j in self.joints
        }

        self.create_subscription(
            JointState,
            '/crustcrawler/joint_states',
            self.joint_state_callback,
            10
        )

        for j in self.joints:
            self.create_subscription(
                Float64,
                f'/pid_controller/{j}_setpoint',
                lambda msg, joint=j: self.setpoint_callback(msg, joint),
                10
            )

        self._last_time = self.get_clock().now()
        self.create_timer(1.0 / 30.0, self.update)

    def joint_state_callback(self, msg):
        for j in self.joints:
            if j in msg.name:
                idx = msg.name.index(j)
                self.current_positions[j] = msg.position[idx]
                self.current_velocities[j] = msg.velocity[idx]

    def setpoint_callback(self, msg, joint):
        self.setpoints[joint] = msg.data

    def update(self):
        now = self.get_clock().now()
        dt = (now - self._last_time).nanoseconds * 1e-9
        if dt <= 0.0:
            return
        self._last_time = now

        for j in self.joints:
            effort = self.pid_controllers[j](
                self.setpoints[j],
                self.current_positions[j],
                self.current_velocities[j],
                dt
            )

            msg = Float64()
            msg.data = effort
            self.publishers[j].publish(msg)

            state_msg = JointControllerState()
            state_msg.header.stamp = self.get_clock().now().to_msg()
            state_msg.set_point = self.setpoints[j]
            state_msg.process_value = self.current_positions[j]
            state_msg.process_value_dot = self.current_velocities[j]
            state_msg.command = effort
            state_msg.error = self.pid_controllers[j].error
            state_msg.p = self.pid_controllers[j].p
            state_msg.i = self.pid_controllers[j].i
            state_msg.d = self.pid_controllers[j].d

            self.state_publishers[j].publish(state_msg)


def main():
    rclpy.init()
    node = MultiJointPIDNode(mode='P')
    rclpy.spin(node)
    node.destroy_node()
    rclpy.shutdown()


if __name__ == '__main__':
    main()
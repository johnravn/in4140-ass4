;; Auto-generated. Do not edit!


(when (boundp 'crustcrawler_msgs::CircleDescription)
  (if (not (find-package "CRUSTCRAWLER_MSGS"))
    (make-package "CRUSTCRAWLER_MSGS"))
  (shadow 'CircleDescription (find-package "CRUSTCRAWLER_MSGS")))
(unless (find-package "CRUSTCRAWLER_MSGS::CIRCLEDESCRIPTION")
  (make-package "CRUSTCRAWLER_MSGS::CIRCLEDESCRIPTION"))

(in-package "ROS")
;;//! \htmlinclude CircleDescription.msg.html
(if (not (find-package "GEOMETRY_MSGS"))
  (ros::roseus-add-msgs "geometry_msgs"))
(if (not (find-package "STD_MSGS"))
  (ros::roseus-add-msgs "std_msgs"))


(defclass crustcrawler_msgs::CircleDescription
  :super ros::object
  :slots (_header _origin _radius _num_points _angle _axis ))

(defmethod crustcrawler_msgs::CircleDescription
  (:init
   (&key
    ((:header __header) (instance std_msgs::Header :init))
    ((:origin __origin) (instance geometry_msgs::Point :init))
    ((:radius __radius) 0.0)
    ((:num_points __num_points) 0)
    ((:angle __angle) 0.0)
    ((:axis __axis) (instance geometry_msgs::Vector3 :init))
    )
   (send-super :init)
   (setq _header __header)
   (setq _origin __origin)
   (setq _radius (float __radius))
   (setq _num_points (round __num_points))
   (setq _angle (float __angle))
   (setq _axis __axis)
   self)
  (:header
   (&rest __header)
   (if (keywordp (car __header))
       (send* _header __header)
     (progn
       (if __header (setq _header (car __header)))
       _header)))
  (:origin
   (&rest __origin)
   (if (keywordp (car __origin))
       (send* _origin __origin)
     (progn
       (if __origin (setq _origin (car __origin)))
       _origin)))
  (:radius
   (&optional __radius)
   (if __radius (setq _radius __radius)) _radius)
  (:num_points
   (&optional __num_points)
   (if __num_points (setq _num_points __num_points)) _num_points)
  (:angle
   (&optional __angle)
   (if __angle (setq _angle __angle)) _angle)
  (:axis
   (&rest __axis)
   (if (keywordp (car __axis))
       (send* _axis __axis)
     (progn
       (if __axis (setq _axis (car __axis)))
       _axis)))
  (:serialization-length
   ()
   (+
    ;; std_msgs/Header _header
    (send _header :serialization-length)
    ;; geometry_msgs/Point _origin
    (send _origin :serialization-length)
    ;; float32 _radius
    4
    ;; int32 _num_points
    4
    ;; float32 _angle
    4
    ;; geometry_msgs/Vector3 _axis
    (send _axis :serialization-length)
    ))
  (:serialize
   (&optional strm)
   (let ((s (if strm strm
              (make-string-output-stream (send self :serialization-length)))))
     ;; std_msgs/Header _header
       (send _header :serialize s)
     ;; geometry_msgs/Point _origin
       (send _origin :serialize s)
     ;; float32 _radius
       (sys::poke _radius (send s :buffer) (send s :count) :float) (incf (stream-count s) 4)
     ;; int32 _num_points
       (write-long _num_points s)
     ;; float32 _angle
       (sys::poke _angle (send s :buffer) (send s :count) :float) (incf (stream-count s) 4)
     ;; geometry_msgs/Vector3 _axis
       (send _axis :serialize s)
     ;;
     (if (null strm) (get-output-stream-string s))))
  (:deserialize
   (buf &optional (ptr- 0))
   ;; std_msgs/Header _header
     (send _header :deserialize buf ptr-) (incf ptr- (send _header :serialization-length))
   ;; geometry_msgs/Point _origin
     (send _origin :deserialize buf ptr-) (incf ptr- (send _origin :serialization-length))
   ;; float32 _radius
     (setq _radius (sys::peek buf ptr- :float)) (incf ptr- 4)
   ;; int32 _num_points
     (setq _num_points (sys::peek buf ptr- :integer)) (incf ptr- 4)
   ;; float32 _angle
     (setq _angle (sys::peek buf ptr- :float)) (incf ptr- 4)
   ;; geometry_msgs/Vector3 _axis
     (send _axis :deserialize buf ptr-) (incf ptr- (send _axis :serialization-length))
   ;;
   self)
  )

(setf (get crustcrawler_msgs::CircleDescription :md5sum-) "5a70b8e621c6258f244ab550ac3bc73e")
(setf (get crustcrawler_msgs::CircleDescription :datatype-) "crustcrawler_msgs/CircleDescription")
(setf (get crustcrawler_msgs::CircleDescription :definition-)
      "# This message describes a circle that is meant to be drawn by the reduced
# Crustcrawler.

# Standard header:
Header header

# Description of the circle to be drawn:
# Origin of the circle
geometry_msgs/Point origin
# Radius of the circle in centimeters
float32 radius
# Number of points describes the total number of points to draw in the circle
# NOTE: Remember that the circle should always be completed
int32 num_points
# The following two arguments describes the orientation of the board using
# axis-angle notation. The angle is in radians
float32 angle
# The axis is a unit vector
geometry_msgs/Vector3 axis

================================================================================
MSG: std_msgs/Header
# Standard metadata for higher-level stamped data types.
# This is generally used to communicate timestamped data 
# in a particular coordinate frame.
# 
# sequence ID: consecutively increasing ID 
uint32 seq
#Two-integer timestamp that is expressed as:
# * stamp.sec: seconds (stamp_secs) since epoch (in Python the variable is called 'secs')
# * stamp.nsec: nanoseconds since stamp_secs (in Python the variable is called 'nsecs')
# time-handling sugar is provided by the client library
time stamp
#Frame this data is associated with
string frame_id

================================================================================
MSG: geometry_msgs/Point
# This contains the position of a point in free space
float64 x
float64 y
float64 z

================================================================================
MSG: geometry_msgs/Vector3
# This represents a vector in free space. 
# It is only meant to represent a direction. Therefore, it does not
# make sense to apply a translation to it (e.g., when applying a 
# generic rigid transformation to a Vector3, tf2 will only apply the
# rotation). If you want your data to be translatable too, use the
# geometry_msgs/Point message instead.

float64 x
float64 y
float64 z
")



(provide :crustcrawler_msgs/CircleDescription "5a70b8e621c6258f244ab550ac3bc73e")



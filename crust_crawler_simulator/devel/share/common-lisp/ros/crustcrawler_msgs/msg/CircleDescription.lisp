; Auto-generated. Do not edit!


(cl:in-package crustcrawler_msgs-msg)


;//! \htmlinclude CircleDescription.msg.html

(cl:defclass <CircleDescription> (roslisp-msg-protocol:ros-message)
  ((header
    :reader header
    :initarg :header
    :type std_msgs-msg:Header
    :initform (cl:make-instance 'std_msgs-msg:Header))
   (origin
    :reader origin
    :initarg :origin
    :type geometry_msgs-msg:Point
    :initform (cl:make-instance 'geometry_msgs-msg:Point))
   (radius
    :reader radius
    :initarg :radius
    :type cl:float
    :initform 0.0)
   (num_points
    :reader num_points
    :initarg :num_points
    :type cl:integer
    :initform 0)
   (angle
    :reader angle
    :initarg :angle
    :type cl:float
    :initform 0.0)
   (axis
    :reader axis
    :initarg :axis
    :type geometry_msgs-msg:Vector3
    :initform (cl:make-instance 'geometry_msgs-msg:Vector3)))
)

(cl:defclass CircleDescription (<CircleDescription>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <CircleDescription>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'CircleDescription)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name crustcrawler_msgs-msg:<CircleDescription> is deprecated: use crustcrawler_msgs-msg:CircleDescription instead.")))

(cl:ensure-generic-function 'header-val :lambda-list '(m))
(cl:defmethod header-val ((m <CircleDescription>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader crustcrawler_msgs-msg:header-val is deprecated.  Use crustcrawler_msgs-msg:header instead.")
  (header m))

(cl:ensure-generic-function 'origin-val :lambda-list '(m))
(cl:defmethod origin-val ((m <CircleDescription>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader crustcrawler_msgs-msg:origin-val is deprecated.  Use crustcrawler_msgs-msg:origin instead.")
  (origin m))

(cl:ensure-generic-function 'radius-val :lambda-list '(m))
(cl:defmethod radius-val ((m <CircleDescription>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader crustcrawler_msgs-msg:radius-val is deprecated.  Use crustcrawler_msgs-msg:radius instead.")
  (radius m))

(cl:ensure-generic-function 'num_points-val :lambda-list '(m))
(cl:defmethod num_points-val ((m <CircleDescription>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader crustcrawler_msgs-msg:num_points-val is deprecated.  Use crustcrawler_msgs-msg:num_points instead.")
  (num_points m))

(cl:ensure-generic-function 'angle-val :lambda-list '(m))
(cl:defmethod angle-val ((m <CircleDescription>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader crustcrawler_msgs-msg:angle-val is deprecated.  Use crustcrawler_msgs-msg:angle instead.")
  (angle m))

(cl:ensure-generic-function 'axis-val :lambda-list '(m))
(cl:defmethod axis-val ((m <CircleDescription>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader crustcrawler_msgs-msg:axis-val is deprecated.  Use crustcrawler_msgs-msg:axis instead.")
  (axis m))
(cl:defmethod roslisp-msg-protocol:serialize ((msg <CircleDescription>) ostream)
  "Serializes a message object of type '<CircleDescription>"
  (roslisp-msg-protocol:serialize (cl:slot-value msg 'header) ostream)
  (roslisp-msg-protocol:serialize (cl:slot-value msg 'origin) ostream)
  (cl:let ((bits (roslisp-utils:encode-single-float-bits (cl:slot-value msg 'radius))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) bits) ostream))
  (cl:let* ((signed (cl:slot-value msg 'num_points)) (unsigned (cl:if (cl:< signed 0) (cl:+ signed 4294967296) signed)))
    (cl:write-byte (cl:ldb (cl:byte 8 0) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) unsigned) ostream)
    )
  (cl:let ((bits (roslisp-utils:encode-single-float-bits (cl:slot-value msg 'angle))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) bits) ostream))
  (roslisp-msg-protocol:serialize (cl:slot-value msg 'axis) ostream)
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <CircleDescription>) istream)
  "Deserializes a message object of type '<CircleDescription>"
  (roslisp-msg-protocol:deserialize (cl:slot-value msg 'header) istream)
  (roslisp-msg-protocol:deserialize (cl:slot-value msg 'origin) istream)
    (cl:let ((bits 0))
      (cl:setf (cl:ldb (cl:byte 8 0) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) bits) (cl:read-byte istream))
    (cl:setf (cl:slot-value msg 'radius) (roslisp-utils:decode-single-float-bits bits)))
    (cl:let ((unsigned 0))
      (cl:setf (cl:ldb (cl:byte 8 0) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) unsigned) (cl:read-byte istream))
      (cl:setf (cl:slot-value msg 'num_points) (cl:if (cl:< unsigned 2147483648) unsigned (cl:- unsigned 4294967296))))
    (cl:let ((bits 0))
      (cl:setf (cl:ldb (cl:byte 8 0) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) bits) (cl:read-byte istream))
    (cl:setf (cl:slot-value msg 'angle) (roslisp-utils:decode-single-float-bits bits)))
  (roslisp-msg-protocol:deserialize (cl:slot-value msg 'axis) istream)
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<CircleDescription>)))
  "Returns string type for a message object of type '<CircleDescription>"
  "crustcrawler_msgs/CircleDescription")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'CircleDescription)))
  "Returns string type for a message object of type 'CircleDescription"
  "crustcrawler_msgs/CircleDescription")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<CircleDescription>)))
  "Returns md5sum for a message object of type '<CircleDescription>"
  "5a70b8e621c6258f244ab550ac3bc73e")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'CircleDescription)))
  "Returns md5sum for a message object of type 'CircleDescription"
  "5a70b8e621c6258f244ab550ac3bc73e")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<CircleDescription>)))
  "Returns full string definition for message of type '<CircleDescription>"
  (cl:format cl:nil "# This message describes a circle that is meant to be drawn by the reduced~%# Crustcrawler.~%~%# Standard header:~%Header header~%~%# Description of the circle to be drawn:~%# Origin of the circle~%geometry_msgs/Point origin~%# Radius of the circle in centimeters~%float32 radius~%# Number of points describes the total number of points to draw in the circle~%# NOTE: Remember that the circle should always be completed~%int32 num_points~%# The following two arguments describes the orientation of the board using~%# axis-angle notation. The angle is in radians~%float32 angle~%# The axis is a unit vector~%geometry_msgs/Vector3 axis~%~%================================================================================~%MSG: std_msgs/Header~%# Standard metadata for higher-level stamped data types.~%# This is generally used to communicate timestamped data ~%# in a particular coordinate frame.~%# ~%# sequence ID: consecutively increasing ID ~%uint32 seq~%#Two-integer timestamp that is expressed as:~%# * stamp.sec: seconds (stamp_secs) since epoch (in Python the variable is called 'secs')~%# * stamp.nsec: nanoseconds since stamp_secs (in Python the variable is called 'nsecs')~%# time-handling sugar is provided by the client library~%time stamp~%#Frame this data is associated with~%string frame_id~%~%================================================================================~%MSG: geometry_msgs/Point~%# This contains the position of a point in free space~%float64 x~%float64 y~%float64 z~%~%================================================================================~%MSG: geometry_msgs/Vector3~%# This represents a vector in free space. ~%# It is only meant to represent a direction. Therefore, it does not~%# make sense to apply a translation to it (e.g., when applying a ~%# generic rigid transformation to a Vector3, tf2 will only apply the~%# rotation). If you want your data to be translatable too, use the~%# geometry_msgs/Point message instead.~%~%float64 x~%float64 y~%float64 z~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'CircleDescription)))
  "Returns full string definition for message of type 'CircleDescription"
  (cl:format cl:nil "# This message describes a circle that is meant to be drawn by the reduced~%# Crustcrawler.~%~%# Standard header:~%Header header~%~%# Description of the circle to be drawn:~%# Origin of the circle~%geometry_msgs/Point origin~%# Radius of the circle in centimeters~%float32 radius~%# Number of points describes the total number of points to draw in the circle~%# NOTE: Remember that the circle should always be completed~%int32 num_points~%# The following two arguments describes the orientation of the board using~%# axis-angle notation. The angle is in radians~%float32 angle~%# The axis is a unit vector~%geometry_msgs/Vector3 axis~%~%================================================================================~%MSG: std_msgs/Header~%# Standard metadata for higher-level stamped data types.~%# This is generally used to communicate timestamped data ~%# in a particular coordinate frame.~%# ~%# sequence ID: consecutively increasing ID ~%uint32 seq~%#Two-integer timestamp that is expressed as:~%# * stamp.sec: seconds (stamp_secs) since epoch (in Python the variable is called 'secs')~%# * stamp.nsec: nanoseconds since stamp_secs (in Python the variable is called 'nsecs')~%# time-handling sugar is provided by the client library~%time stamp~%#Frame this data is associated with~%string frame_id~%~%================================================================================~%MSG: geometry_msgs/Point~%# This contains the position of a point in free space~%float64 x~%float64 y~%float64 z~%~%================================================================================~%MSG: geometry_msgs/Vector3~%# This represents a vector in free space. ~%# It is only meant to represent a direction. Therefore, it does not~%# make sense to apply a translation to it (e.g., when applying a ~%# generic rigid transformation to a Vector3, tf2 will only apply the~%# rotation). If you want your data to be translatable too, use the~%# geometry_msgs/Point message instead.~%~%float64 x~%float64 y~%float64 z~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <CircleDescription>))
  (cl:+ 0
     (roslisp-msg-protocol:serialization-length (cl:slot-value msg 'header))
     (roslisp-msg-protocol:serialization-length (cl:slot-value msg 'origin))
     4
     4
     4
     (roslisp-msg-protocol:serialization-length (cl:slot-value msg 'axis))
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <CircleDescription>))
  "Converts a ROS message object to a list"
  (cl:list 'CircleDescription
    (cl:cons ':header (header msg))
    (cl:cons ':origin (origin msg))
    (cl:cons ':radius (radius msg))
    (cl:cons ':num_points (num_points msg))
    (cl:cons ':angle (angle msg))
    (cl:cons ':axis (axis msg))
))

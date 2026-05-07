
(cl:in-package :asdf)

(defsystem "crustcrawler_msgs-msg"
  :depends-on (:roslisp-msg-protocol :roslisp-utils :geometry_msgs-msg
               :std_msgs-msg
)
  :components ((:file "_package")
    (:file "CircleDescription" :depends-on ("_package_CircleDescription"))
    (:file "_package_CircleDescription" :depends-on ("_package"))
  ))
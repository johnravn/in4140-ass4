import sys
if sys.prefix == '/usr':
    sys.real_prefix = sys.prefix
    sys.prefix = sys.exec_prefix = '/uio/hume/student-u88/johnrav/in4140/pid_assignment/install/pid_assignment'

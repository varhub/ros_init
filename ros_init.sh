# Copyright 2014 varribas <v.arribas.urjc@gmail.com>

# >>Variables<<
# ROS develop workspace
ROS_WS=~/ros_workspace
ROS_PORT=11511
ROS_MASTER_URI=http://Ubuntu14lts:$ROS_PORT/

# >>ROS related<<
# Move to workspace
cd $ROS_WS

# Change ROS Core port (this allow multiple instances)
export ROS_MASTER_URI

# Load ROS environment
source /opt/ros/fuerte/setup.sh


# >>Graphical mode execution<<
# This is a chroot environment, so for graphics...
export DISPLAY=:0

# ROS core
xterm -T "ROS core" -geometry 80x30+0+100 -e "roscore -p $ROS_PORT" &

# Terminal invoker
xterm -T "ROS terminal launcher" -geometry 40x3+0+0 -e '
	while true
	do
	echo "Press Ctrl+C for a complete exit"
	echo "Press enter to open a new console ;)"
	read
	x-terminal-emulator &
	done' &

# Default develop terminal
#x-terminal-emulator &

# Copyright 2014 varribas <v.arribas.urjc@gmail.com>


set -e # exit on command error (attention: all commands must run successfully. Add "|| true" if it can fail)
# It ensures stop and halt on a fail (for example: no ros distro)
# Issue: halt behavior is passed on childs (unwanted)


## >>Configuration<< ##
## ROS workspaces (at $ROS_BASE_WS/<ros_version>)
# This is the full/related path that will be the root directory that
# will hold the isolated workspaces.
ROS_BASE_WS=~/ros_workspace

## MASTER URI (explicit customize)
# The machine's hosname of the roscore node
ROS_HOSTNAME=localhost
# The roscore listen port
#ROS_PORT=11311



## >>Preparing ROS workspace<< ##
## Detect ros version
ROS_DISTRO=$(find /opt/ros/ -mindepth 1  -maxdepth 1 -type d -printf "%f" -quit)


## Set ROS_MASTER_URI
# Default hostname if not defined
[ -z $ROS_HOSTNAME ] && ROS_HOSTNAME=localhost
# Pseudo dynamic port (diferent by distro)
if [ -z $ROS_PORT ]; then
	ROS_PORT=$(( 11300 + $(printf '%d' "'$ROS_DISTRO'") - 97))
fi
# Override master uri
ROS_MASTER_URI=http://$ROS_HOSTNAME:$ROS_PORT/


## Force isolated environment. This is done through $HOME switch
# Check for recursion. Is $HOME already changed?
ROS_WS=${ROS_BASE_WS}/${ROS_DISTRO}
if echo $ROS_WS | grep -q "$ROS_DISTRO.*$ROS_DISTRO$"
then
	echo 'Warning: Isolated workspace already injected into $HOME. Skipping...'
	ROS_WS=$HOME
fi

# Move to workspace
[ -d "${ROS_WS}" ] || mkdir -p "${ROS_WS}"
cd "$ROS_WS"

# Switch user's HOME to ROS_WS to force isolation (for example: ~/.ros/log/)
export HOME=$ROS_WS

# Change ROS Core port (this allow multiple instances)
export ROS_MASTER_URI


## >>Load ROS environment (the normal invocation)<< ##
if [ -n "$BASH" ]; then
	source /opt/ros/$ROS_DISTRO/setup.bash
elif [ -n "$ZSH_NAME" ]; then
	source /opt/ros/$ROS_DISTRO/setup.zsh
else
	source /opt/ros/$ROS_DISTRO/setup.sh
fi


## >>Graphical mode execution<< ##
# If this is a chroot environment, DISPLAY is required
[ -z $DISPLAY ] && export DISPLAY=:0

# Solves xterm warning
# Warning: Tried to connect to session manager, None of the authentication protocols specified are supported
unset SESSION_MANAGER

# revert set -e issue: force close of develop terminal on command exit != 0
# if this happends into the main terminal, roscore and launched terminals will be
# closed and furthermore, it shutdown chroot
set +e

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

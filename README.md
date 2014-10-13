# ros_init #
ros_init.sh is a script that serves a little X based ROS environment.
It has been created for chroot environments. So the idea is to allow
multiple instances.

State: BETA 

## Requirements ##
* ROS, as logic
* X11
  * xterm
  * x-terminal-emulator (a.k.a your favourite terminal ;))
* Minimal bash commands

## use it ##
Instead of put `source /opt/ros/<version>/setup.sh` into your .bashrc 
or write it in each new terminal (you can avoid it in gnome-terminal 
with Ctrl+Shift+T), this alternative will run 'roscore' and a little 
xterm as a terminal launcher.


## for chroot ##
I'm using schroot and it automatically mounts my home.
And, for an unattended start, I have added a little trap 
in my ~/.profile `df -h 2>/dev/null || . ros_workspace/ros_init.sh`
A chroot environment can't handle df command, so it would fail.
Therefore, it will load ros in my chroots but won't do it in the host.

Note that **schroot** tries to cd to *pwd* first, and to *HOME* on fail
(and finally to */*). So, I use it on my favor:
* cd ~ && schroot -c *chroot's name*
  * This will invoke ros_init.sh
* cd / && schroot -c *chroot's name*
  * This won't invoke ros_init.sh

This is due to I source **./ros_init** instead of **~/ros_init**.


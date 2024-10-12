#!/bin/sh

# use dbus-launch to silence
# (process:8): dconf-WARNING **: 09:22:34.388: failed to commit changes to dconf: Cannot autolaunch D-Bus without X11 $DISPLAY
exec /usr/bin/dbus-launch "$@"

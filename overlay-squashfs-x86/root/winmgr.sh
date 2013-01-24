#!/bin/sh

# --- new environment: xfce
exec ck-launch-session dbus-launch /usr/bin/startxfce4 >/dev/null 2>&1

# --- old environment: jwm
#exec /usr/bin/jwm >/dev/null 2>&1


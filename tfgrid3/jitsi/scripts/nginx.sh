#!/bin/sh

PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
DAEMON=/usr/sbin/nginx
NAME=nginx
DESC=nginx

# Include nginx defaults if available
if [ -r /etc/default/nginx ]; then
        . /etc/default/nginx
fi

STOP_SCHEDULE="${STOP_SCHEDULE:-QUIT/5/TERM/5/KILL/5}"

test -x $DAEMON || exit 0

. /lib/init/vars.sh
. /lib/lsb/init-functions

# Try to extract nginx pidfile
PID=$(cat /etc/nginx/nginx.conf | grep -Ev '^\s*#' | awk 'BEGIN { RS="[;{}]" } { if ($1 == "pid") print $2 }' | head -n1)
if [ -z "$PID" ]; then
        PID=/run/nginx.pid
fi

if [ -n "$ULIMIT" ]; then
        # Set ulimit if it is set in /etc/default/nginx
        ulimit $ULIMIT
fi

start_nginx() {
        # Start the daemon/service
        #
        # Returns:
        #   0 if daemon has been started
        #   1 if daemon was already running
        #   2 if daemon could not be started
        start-stop-daemon --start --quiet --pidfile $PID --exec $DAEMON --test > /dev/null \
                || return 1
        start-stop-daemon --start --quiet --pidfile $PID --exec $DAEMON -- \
                $DAEMON_OPTS 2>/dev/null \
                || return 2
}


log_daemon_msg "Starting $DESC" "$NAME"
start_nginx
case "$?" in
        0|1) log_end_msg 0 ;;
        2)   log_end_msg 1 ;;
esac
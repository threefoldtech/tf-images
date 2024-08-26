#!/bin/bash

. /lib/lsb/init-functions

# Include jicofo defaults if available
if [ -f /etc/jitsi/jicofo/config ]; then
    . /etc/jitsi/jicofo/config
fi

PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
DAEMON=/usr/share/jicofo/jicofo.sh
DAEMON_DIR=/usr/share/jicofo/
NAME=jicofo
USER=jicofo
PIDFILE=/var/run/jicofo.pid
LOGFILE=/var/log/jitsi/jicofo.log
DESC=jicofo


if [ ! -x $DAEMON ] ;then
  echo "Daemon not executable: $DAEMON"
  exit 1
fi

set -e


start() {
    if [ -f $PIDFILE ]; then
        echo "$NAME seems to be already running, we found pidfile $PIDFILE."
        exit 1
    fi
    echo -n "Starting $NAME: "
    export JICOFO_AUTH_PASSWORD JICOFO_MAX_MEMORY
    start-stop-daemon --start --quiet --background --chuid $USER --make-pidfile --pidfile $PIDFILE \
        --exec /bin/bash -- -c "cd $DAEMON_DIR; JAVA_SYS_PROPS=\"$JAVA_SYS_PROPS\" exec $DAEMON $JICOFO_OPTS < /dev/null >> $LOGFILE 2>&1"
    echo "$NAME started."
}

start
#!/bin/bash


. /lib/lsb/init-functions

# Include videobridge defaults if available
if [ -f /etc/jitsi/videobridge/config ]; then
    . /etc/jitsi/videobridge/config
fi

PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
DAEMON=/usr/share/jitsi-videobridge/jvb.sh
NAME=jvb
USER=jvb
# A tmpfs backed directory just for the JVB process. This is introduced
# to hold packet arrival times, but it may be otherwise useful in the future.
TMPPATH=/var/run/jitsi-videobridge
PIDFILE=/var/run/jitsi-videobridge.pid
LOGFILE=/var/log/jitsi/jvb.log
DESC=jitsi-videobridge


if [ ! -d "$TMPPATH" ]; then
    mkdir "$TMPPATH"
    chown $USER:adm "$TMPPATH"
fi

if [ ! $JVB_HOST ]; then
    JVB_HOST=localhost
fi
# TODO: remove this when support for --apis is removed
DAEMON_OPTS="$JVB_OPTS"

if [ ! -x $DAEMON ] ;then
  echo "Daemon not executable: $DAEMON"
  exit 1
fi

set -e


start() {
    if [ -f $PIDFILE ]; then
        echo "$DESC seems to be already running, we found pidfile $PIDFILE."
        exit 1
    fi
    echo -n "Starting $DESC: "
    DAEMON_START_CMD="JAVA_SYS_PROPS=\"$JAVA_SYS_PROPS\" exec $DAEMON $DAEMON_OPTS < /dev/null >> $LOGFILE 2>&1"
    AUTHBIND_CMD=""
    if [ "$AUTHBIND" = "yes" ]; then
        AUTHBIND_CMD="/usr/bin/authbind --deep /bin/bash -c "
        DAEMON_START_CMD="'$DAEMON_START_CMD'"
    fi
    start-stop-daemon --start --quiet --background --chuid $USER --make-pidfile --pidfile $PIDFILE \
        --exec /bin/bash -- -c "$AUTHBIND_CMD $DAEMON_START_CMD"
    echo "$NAME started."
}

start
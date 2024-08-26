#!/bin/bash

set -e


USER=prosody
DAEMON=/usr/bin/prosody
PIDPATH=/run/prosody
PIDFILE="$PIDPATH"/prosody.pid
RUNTIME=

NICE=
MAXFDS=
CPUSCHED=
IOSCHED=

test -x "$DAEMON" || exit 0

. /lib/lsb/init-functions

if [ -f /etc/default/prosody ] ; then
    . /etc/default/prosody
fi

start_opts() {
        test -z "$NICE"     || printf " --nicelevel %s" $NICE
        test -z "$CPUSCHED" || printf " --procsched %s" $CPUSCHED
        test -z "$IOSCHED"  || printf " --iosched %s" $IOSCHED
        test -n "$RUNTIME"  || printf " --startas %s -- -D" "$DAEMON"
        test -z "$RUNTIME"  || printf " --exec %s -- %s -D" "$RUNTIME" "$DAEMON"
}

test -z "$MAXFDS" || ulimit -n "$MAXFDS"


if [ ! -d "$PIDPATH" ]; then
        mkdir "$PIDPATH";
        chown "$USER:adm" "$PIDPATH";
fi

# Check that user 'prosody' exists
check_user() {
        if ! getent passwd "$USER" >/dev/null; then
                exit 1;
        fi
}

start_prosody () {
        mkdir -p "$(dirname $PIDFILE)"
        chown prosody:adm "$(dirname $PIDFILE)"
        [ -x /sbin/restorecon ] && /sbin/restorecon `dirname $PIDFILE`
        if start-stop-daemon --start --quiet --pidfile "$PIDFILE" \
                --chuid "$USER" --oknodo --user "$USER" \
                $(start_opts);
        then
                return 0
        else
                return 1
        fi
}


check_user
log_daemon_msg "Starting Prosody XMPP Server" "prosody"
if start_prosody; then
        log_end_msg 0;
else
        log_end_msg 1;
fi
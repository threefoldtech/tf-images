#!/bin/bash
# Script to add a user to Linux system

if [ $(id -u) -eq 0 ]; then
	egrep "^$SUPERUSER_USERNAME" /etc/passwd >/dev/null
	if [ $? -eq 0 ]; then
		echo "$SUPERUSER_USERNAME exists!"
		exit 1
	else
		pass=$(perl -e 'print crypt($ARGV[0], "password")' $SUPERUSER_PASSWORD)
		useradd -m -p $pass $SUPERUSER_USERNAME
		[ $? -eq 0 ] && echo "User has been added to system!" || echo "Failed to add a user!"
		exit 0
	fi
else
	echo "Only root may add a user to the system"
	exit 2
fi
#!/bin/bash

SFTP_BASE="/var/sftp"

if [ $# -lt 1 ]; then
    echo -e "Usage:  $0 [username]"
    exit 1
else
    if id "$1" &> /dev/null; then
        echo "Removing $1 sftp user and its directory $SFTP_BASE/$1."
        if mountpoint -q "$SFTP_BASE/$1/dev/log"; then
            umount "$SFTP_BASE/$1/dev/log"
        fi
        userdel "$1"
        rm -rf "$SFTP_BASE/$1"
        echo "SFTP user $1 removed successfully."
    else
        echo "$1 sftp user doesn't exist on server"
        exit 1
    fi
fi

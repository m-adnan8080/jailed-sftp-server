#!/bin/bash

if [ $# -lt 1 ]; then
    echo -e "Usage:  $0 [username]"
    exit 1
else
    if id "$1" &> /dev/null; then
        echo "Removing $1 sftp user and its directory /var/sftp/$1."
        deluser --force $1
	rm -rf /var/sftp/$1
    else
        echo "$1 sftp user doesn't exists on server"
        exit 1;
    fi
fi
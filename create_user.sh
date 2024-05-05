#!/bin/bash

if [ $# -lt 2 ]; then
    echo -e "Usage:  $0 [username] [password]"
    exit 1
else
    if id "$1" &> /dev/null; then
        echo "$1 sftp user already exists on server."
        exit 1;
    else
        echo "Create sftp user $1"
        useradd -s /bin/false $1 -d /var/sftp/$1
        usermod -aG sftp_users $1

        mkdir -p /var/sftp/$1

        echo "$1:$2" | chpasswd $1
        mkdir -p /var/sftp/$1/upload
        chown $1:$1 /var/sftp/$1/upload
    fi
fi

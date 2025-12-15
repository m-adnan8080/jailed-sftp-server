#!/bin/bash

SFTP_GROUP="sftpusers"
SFTP_BASE="/var/sftp"
SRC_LOG="/dev/log"

if [ $# -lt 2 ]; then
    echo -e "Usage:  $0 [username] [password]"
    exit 1
else
    if id "$1" &> /dev/null; then
        echo "$1 sftp user already exists on server."
        exit 1
    else
        echo "Create sftp user $1"
        useradd -s /bin/false -d "$SFTP_BASE/$1" "$1"
        usermod -aG "$SFTP_GROUP" "$1"

        mkdir -p "$SFTP_BASE/$1/upload" "$SFTP_BASE/$1/dev"

        echo "$1:$2" | chpasswd

        chown root:root "$SFTP_BASE/$1"
        chmod 755 "$SFTP_BASE/$1"
        chown "$1:$1" "$SFTP_BASE/$1/upload"
        chmod 750 "$SFTP_BASE/$1/upload"

        # /dev/log setup for logging
        touch "$SFTP_BASE/$1/dev/log"
        chown root:root "$SFTP_BASE/$1/dev" "$SFTP_BASE/$1/dev/log"
        chmod 755 "$SFTP_BASE/$1/dev"
        chmod 600 "$SFTP_BASE/$1/dev/log"

        # Bind-mount /dev/log into chroot
        if ! mountpoint -q "$SFTP_BASE/$1/dev/log"; then
            mount --bind "$SRC_LOG" "$SFTP_BASE/$1/dev/log"
        fi

        echo "SFTP user $1 created with logging enabled."
    fi
fi

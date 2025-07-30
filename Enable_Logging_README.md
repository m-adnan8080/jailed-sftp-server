
# OpenSSH SFTP Server Logging for Jailed Users

This guide enables logging of file upload/download/delete events on an OpenSSH-based SFTP server for jailed (chrooted) users.

---

## 1. `sshd_config` Setup

```bash
Subsystem sftp internal-sftp -f LOCAL6 -l VERBOSE

Match Group sftpusers
    ChrootDirectory %h
    ForceCommand internal-sftp -f LOCAL6 -l VERBOSE
    AllowTcpForwarding no
    PermitTunnel no
    AllowAgentForwarding no
    X11Forwarding no
    PasswordAuthentication yes
    LogLevel INFO
```

---

## 2. Configure rsyslog and logrotate

```bash
# /etc/rsyslog.d/sftp.conf
local6.* /var/log/sftp.log
```

```bash
# /etc/logrotate.d/sftp
/var/log/sftp.log {
  daily
  rotate 7
  compress
  missingok
  notifempty
  create 640 root adm
}
```

---

## 3. Bash Script for All `sftpusers`
Add user (example)
```bash
sudo useradd -m -s /usr/sbin/nologin -G sftpusers test
sudo mkdir -p /home/test/uploads
sudo chown root:root /home/test
sudo chmod 755 /home/test
sudo chown test:sftpusers /home/test/uploads
sudo chmod 755 /home/test/uploads
```

---

## 4. Fix Logging in Chroot (Jailed) Users
This script will create the `dev` directory in all sftp users home directory in `sftpusers` group and mount the log to push logs to `/var/log/sftp.logs` file.

```bash
#!/bin/bash

SFTP_GROUP="sftpusers"
SRC_LOG="/dev/log"
getent group "$SFTP_GROUP" | awk -F: '{print $4}' | tr ',' '\n' | while read -r user; do
    HOME_DIR=$(eval echo "~$user")
    if [[ -d "$HOME_DIR" ]]; then
        TARGET_DEV_DIR="$HOME_DIR/dev"
        if [[ ! -f "$TARGET_DEV_DIR/log" ]]; then
            sudo mkdir -p "$TARGET_DEV_DIR"
            sudo touch "$TARGET_DEV_DIR/log"
        fi
        if ! mountpoint -q "$TARGET_DEV_DIR/log"; then
            sudo mount --bind "$SRC_LOG" "$TARGET_DEV_DIR/log"
        fi
    fi
done
```
---
**NOTE:** The change is not persitent means on server restart the sftp logging will be gone. To make it persistent add the script to system startup or schedule using crontab to cater new user creation and enable logging as well.

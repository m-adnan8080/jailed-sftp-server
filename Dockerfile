FROM ubuntu:20.04

# Install SSH server and dependencies
RUN apt-get update && \
    apt-get install -y openssh-server openssl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Create group and user for SFTP
RUN groupadd sftp_users && \
    mkdir /var/sftp /run/sshd && \
    chown root:sftp_users /var/sftp && \
    chmod 755 /var/sftp

# Copy SSH configuration
COPY sshd_config /etc/ssh/sshd_config

# Generate SSH host keys
RUN ssh-keygen -A

# Expose SSH port
EXPOSE 22

# Add script to create SFTP users and set up their directories
COPY create_user.sh /usr/local/bin/create_user.sh
RUN chmod +x /usr/local/bin/create_user.sh

# Add script to delete SFTP users and their directories
COPY del_user.sh /usr/local/bin/del_user.sh
RUN chmod +x /usr/local/bin/del_user.sh

# Start SSH server
CMD ["/usr/sbin/sshd", "-D"]

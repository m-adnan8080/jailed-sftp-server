# SFTP Server in docker container
SFTP Server on Ubuntu 20.04 using openssh-server with user jail to it home directory on SFTP and no ssh login allowed for SFTP users.

# Usage

1. Install docker

2. Download and start the SFTP server instance:
   
      `docker run -d -p 2222:22 --name sftp-server adnan80/docker-sftp-server`

3. Adding new SFTP user on SFTP server

      `docker exec -it sftp-server create_user.sh user1 P@ssword`

4. Remove SFTP user from server
   
      `docker exec -it sftp-server del_user.sh user2`
   
   Note: The del_user.sh will delete the user home_dir recursively. 

5. Test the SFTP user to login

      `sftp -p 2222 user1@localhost`
   
      `sftp> pwd`

      `sftp> /` 

5. [Optional] Stop the SFTP docker container instance:

      `docker stop sftp-server`

6. [Optional] Delete the SFTP docker container instance (after stopping it)

      `docker rm sftp-server`

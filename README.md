# SFTP Server in docker container
LAMP Server on Ubuntu 16.04 with nano, git, PHP-7.0, Apache2, MySQL-5.7 and phpMyAdmin

# Usage

1. Install docker

2. Download and start the SFTP server instance:
   
      `docker run -d -p 2222:22 --name sftp-server adnan80/docker-sftp-server`

3. Adding new SFTP user on SFTP server

      `docker exec -it sftp-server create_user.sh user1 P@ssword`

4. Remove SFTP user from server
   
      `docker exec -it sftp-server del_user.sh user2`
   
   Note: The del_user.sh will delete the user home_dir recursively. 

5. [Optional] Stop the lamp docker container instance:

      `docker stop sftp-server`

6. [Optional] Delete the lamp docker container instance (after stopping it)

      `docker rm sftp-server`

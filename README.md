# Apache and Nginx Setup Script

This script automates the setup and configuration of Apache web servers and an Nginx machine acting as a reverse proxy. It uses Bash shell commands and SSH connections to remote servers to perform the following tasks:

- Set the hostname of the remote server.
- Add http and https services to the remote server's firewall.
- Install Apache or Nginx packages on the remote server.
- Enable and restart Apache or Nginx services on the remote server.
- Add an index.html file to the remote server's Apache document root.
- Add an upstream configuration file to the remote server's Nginx configuration.


The script is designed to be run on a local machine, which requires an SSH connection to the remote servers. The script assumes that you have root access to the remote servers and that they are running a compatible Linux distribution that uses the yum package manager.

## Requirements

To run the script, you need the following:

* A local machine with Bash shell and SSH client installed.
* Remote servers running a compatible Linux distribution with root access and SSH server running (tested on CentOS 7).
* SSH access to the remote servers.

## Usage

1. Clone the project repository to your local machine.
2. Make sure the script files have execute permissions: `chmod +x functions.sh main.sh`.
3. Edit the script file `config` and replace the values of the variables at the beginning of the files to match your environment.
4. Run the scripts in the order you prefer, for example: `./main.sh config`.
5. The scripts will prompt you for the remote server's root password if required.
6. Wait for the scripts to finish, and verify that the Apache or Nginx services are running correctly.

## Limitations

The script is provided as-is, and there are some limitations and assumptions to consider:

* The script assumes that you have root access to the remote servers and that they are running a compatible Linux distribution that uses the yum package manager.
* The script may overwrite existing configuration files or directories without warning.
* The script does not configure SSL certificates or HTTPS redirection for Apache or Nginx.
* The script does not configure any virtual hosts or load balancing for Nginx.
* The script does not handle any errors or exceptions gracefully.

## License

This project is licensed under the [MIT License](https://opensource.org/licenses/MIT).. Feel free to use, modify, and distribute the code as long as you include the original license and copyright notice.

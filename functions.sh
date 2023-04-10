#!/bin/bash
###### The required Functions for the script
# function that will set hostname
function SetHostName() {
	IP=${1}
	HostName=${2}
	ssh root@${IP} "hostnamectl set-hostname ${HostName}"	
}
################################################################
# function will add http,https to firewall
function FireWall() {
	IP=${1}
	ssh root@${IP} "firewall-cmd --permanent --add-service={http,https};
			firewall-cmd --reload"
}
################################################################
# function will install packages 
function InstallPackage() {
	IP=${1}
	ServiceName=${2}
	ssh root@${IP} "yum install ${ServiceName}"  
}
################################################################
# function will enable service
function EnableService() {
        IP=${1}
        ServiceName=${2}
        ssh root@${IP} "systemctl enable ${ServiceName}"
}
################################################################
# function will restart service
function RestartService() {
        IP=${1}
        ServiceName=${2}
        ssh root@${IP} "systemctl restart ${ServiceName}"
}
################################################################
# function will Add index
function AddIndex() {
        IP=${1}
        Text=${2}
        ssh root@${IP} "echo ${Text} > /var/www/html/index.html"
}
################################################################
# function will Add Upstream
function AddUpstream() {
        IP=${1}
        Text=${2}
        ssh root@${IP} "echo -e \"${Text}\" > /etc/nginx/conf.d/upstream.conf"
}

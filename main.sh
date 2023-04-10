#!/bin/bash
### Script reads the config file, and install backend servers, as long as load balancer using nginx
### Exit codes:
##	0: Success
##	1: config file not found
##	2: config file has not read permission
[ ! -f config ] && echo "Error: Can not find config	uration file" && exit 1
[ ! -r config ] && echo "Error: Can not read configuration file" && exit 2
source ./function.sh

# Read the backend and reverse proxy from the config file
BACKEND=()
while read LINE
do
    TYPE=$(echo ${LINE} | cut -d= -f 1)
    ADDRESS=$(echo ${LINE
done
} | cut -d= -f 2)
    if [ ${TYPE} == "BACKEND"]
    then
        BACKEND+=(${ADDRESS})
    fi
    if [ ${TYPE} == "REVPROXY"]
    then   
       REVPROXY=${ADDRESS}
    fi
done < config
############################################################
# set hostname for reverse proxy
echo "Proxy address : ${REVPROXY}"
echo -e -n "Set hostname for reverse proxy "
SetHostName ${REVPROXY} "nginx"
echo " .. done"
#####################################################
# install nginx for reverse proxy
echo -e -n "Install NGINX on reverse proxy"
InstallPackage ${REVPROXY} "nginx"
echo " .. done"
#####################################################
# enable http in firewall for reverse proxy
echo -e -n "Add http in firewalld for reverse proxy "
FireWall ${REVPROXY}
echo " .. done"
#####################################################
# enable nginx 
echo -e -n "Enable NGINX on reverse proxy"
EnableService ${REVPROXY} "nginx"
echo " .. done"
#####################################################
# restart nginx
echo -e -n "Restart NGINX on reverse proxy"
RestartService ${REVPROXY} "nginx"
echo " .. done"
#####################################################
# add upstream to nginx
echo -e -n "Adding upstream servers"
UPSTREAM="upstream backend {"
for IP in ${BACKEND[@]}
do
	UPSTREAM="${UPSTREAM}\n\tserver ${IP};"
done
UPSTREAM="${UPSTREAM}\n}"
AddUpstream ${REVPROXY} "${UPSTREAM}"
echo ".. done"
#####################################################
# add proxy pass to nginx 
echo -e -n "Adding proxy pass"
ssh root@${REVPROXY} "sed -i 's/^[ ]*location \/ {/\tlocation \/ { \n\t\tproxy_pass http:\/\/itihttpd;/g' /etc/nginx/nginx.conf"
echo ".. done"
#####################################################
# enable selinux boolean
echo -e -n :"Enable selinux boolean"
ssh root@${REVPROXY} "setsebool -P httpd_can_network_connect on"
echo " .. done"
#####################################################
# restarting nginx 
echo -e -n :"Restartign nginx service on reverse proxy"
RestartService ${REVPROXY} "nginx"
echo " .. done"
#####################################################
clear
echo "Backend servers addresses : "
SEQ=1
for IP in ${BACKEND[@]}
do
    echo -e "\t Backend : ${IP} with hostname ${HOSTNAME}"
    echo -e -n "\t\tSet hostname for ${IP} "
        SetHostName ${IP} ${HOSTNAME}
        echo " .. done"
        echo -e -n "\t\tpermit http for ${IP} "
		FireWall ${IP}
		echo " .. done"
        echo -e -n "\t\tInstall httpd on ${IP}"
		InstallPackage ${IP} "httpd"
		echo " .. done"
        echo -e -n "\t\tEnable httpd on ${IP}"
		EnableService ${IP} "httpd"
		echo " .. done"
        echo -e -n "\t\tRestart httpd on ${IP}"
	    RestartService ${IP} "httpd"
		echo " .. done"
        echo -e -n "\t\tAdding index page on ${IP}"
		AddIndex ${IP} "Welcome to node ${HOSTNAME}"
		echo " .. done"
        SEQ=$[SEQ+1]
done
echo "Done, thank you .."
exit 0
        

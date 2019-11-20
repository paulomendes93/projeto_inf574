#!/bin/bash
#

### WEBSERVER
for maq in www1 www2
do
	echo "Instalando NGINX em $maq"
	lxc exec $maq -- apt update
	lxc exec $maq -- apt upgrade -y
	lxc exec $maq -- apt install -y nginx
	
	echo "Alterando aquivo index em $maq"
	lxc file push ./conf/$maq/index.nginx-debian.html $maq/var/www/html/index.nginx-debian.html
done

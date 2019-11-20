#!/bin/bash
#

### WEBSERVER
for maq in www1 www2
do
	echo "Instalando e configurando $maq"
	lxc exec $maq -- apt update
	lxc exec $maq -- apt upgrade -y
	lxc exec $maq -- apt install -y nginx
done

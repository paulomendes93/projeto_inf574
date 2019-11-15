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


###
# redirecionando a porta 8080 e 8081 para o servidor na porta 80 no container www1 e www2
#lxc config device add www1 myport8080 proxy listen=tcp:0.0.0.0:8080 connect=tcp:10.10.10.10:80
#lxc config device add www2 myport8081 proxy listen=tcp:0.0.0.0:8081 connect=tcp:10.10.10.11:80
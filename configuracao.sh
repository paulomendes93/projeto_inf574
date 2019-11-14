#!/bin/bash
#

### WEBSERVER
for maq in www1 www2
do
	echo "Instalando e configurando $maq"
	lxc exec $maq -- apt update
	lxc exec $maq -- apt upgrade -y
	lxc exec $maq -- apt install -y nginx
	
	echo "Apagando arquivo index.html em $maq"
	lxc file delete $maq/var/www/html/index.html
	
	echo "Copiando arquivos exemplo para $maq"
	lxc file push ./conf/exemplos/index.php $maq/var/www/html/index.php
	lxc file push ./conf/exemplos/1.php $maq/var/www/html/1.php
done


###
# redirecionando a porta 8081 e 8082 para o servidor na porta 80 no container nginx
lxc config device add www1 myport8081 proxy listen=tcp:0.0.0.0:8081 connect=tcp:0.0.0.0:80
lxc config device add www2 myport8082 proxy listen=tcp:0.0.0.0:8082 connect=tcp:0.0.0.0:80
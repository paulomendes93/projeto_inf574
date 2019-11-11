#!/bin/bash
# gera dois container com nginx e libera acesso para a porta 8081 e 8082
#
#echo "Criando redes"
#lxc network create redeWWW ipv4.address=10.10.80.1/27 ipv4.nat=false ipv4.dhcp=false

echo "Criando o container www1 e www2"
lxc copy debian9padrao www1
lxc copy debian9padrao www2

#echo "Ligando interface eth0 na rede interna"
#lxc network attach redeWWW www1 eth0
#lxc network attach redeWWW www2 eth0

echo "Copiando configuracao de rede www1 e www2"
lxc file push ./conf/www1/interfaces www1/etc/network/interfaces
lxc file push ./conf/www2/interfaces www2/etc/network/interfaces

echo "Iniciando container"
lxc start www1
lxc start www2

echo "Aguardando 5 segundos para inicialização"
sleep 5

### NGINX
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
# redirecionando a porta 8080 para o servidor na porta 80 no container nginx
lxc config device add www1 myport8081 proxy listen=tcp:0.0.0.0:8081 connect=tcp:0.0.0.0:80
lxc config device add www2 myport8082 proxy listen=tcp:0.0.0.0:8082 connect=tcp:0.0.0.0:80

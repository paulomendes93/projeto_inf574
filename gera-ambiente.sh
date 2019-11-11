#!/bin/bash
# gera um container com www1 e libera acesso para a porta 8080
#  
echo "Criando o container www1"
lxc copy debian9padrao www1

echo "Copiando configuracao de rede"
lxc file push ./conf/www1/interfaces www1/etc/network/interfaces

echo "Iniciando container"
lxc start www1

echo "Aguardando 5 segundos para inicialização"
sleep 5

### www1
echo "Instalando e configurando www1"
lxc exec www1 -- apt update
lxc exec www1 -- apt upgrade -y
lxc exec www1 -- apt install -y www1
echo "Apagando arquivo index.html em www1"
lxc file delete $1/var/www/html/index.html
echo "Copiando arquivos exemplo para www1"
lxc file push ./conf/www1/index.php $1/var/www/html/index.php
lxc file push ./conf/www1/1.php $1/var/www/html/1.php

###
# redirecionando a porta 8080 para o servidor na porta 80 no container www1
lxc config device add www1 myport8080 proxy listen=tcp:0.0.0.0:8080 connect=tcp:0.0.0.0:80

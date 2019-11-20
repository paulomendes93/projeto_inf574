#!/bin/bash
# criando containers

#WEBSERVER
echo "Criando o container www1 e www2"
lxc copy debian9padrao www1
lxc copy debian9padrao www2

echo "Ligando interface eth0 na rede interna"
lxc network attach redeFWSRV www1 eth0
lxc network attach redeFWSRV  www2 eth0

echo "Copiando configuracao de rede www1 e www2"
lxc file push ./conf/www1/interfaces www1/etc/network/interfaces
lxc file push ./conf/www2/interfaces www2/etc/network/interfaces


#GERENCIAMENTO
echo "Criando o container log e zabbix"
lxc copy debian9padrao log
lxc copy debian9padrao zabbix

echo "Ligando interface eth0 na rede interna"
lxc network attach redeFWSRV log eth0
lxc network attach redeFWSRV zabbix eth0

echo "Copiando configuracao de rede log e zabbix"
lxc file push ./conf/log/interfaces log/etc/network/interfaces
lxc file push ./conf/zabbix/interfaces zabbix/etc/network/interfaces


#DMZ
echo "Criando o container ssh e proxy"
lxc copy debian9padrao ssh
lxc copy debian9padrao proxy

echo "Ligando interface eth0 na rede interna"
lxc network attach redeFWDMZ ssh eth0
lxc network attach redeFWDMZ proxy eth0

echo "Copiando configuracao de rede ssh e proxy"
lxc file push ./conf/ssh/interfaces ssh/etc/network/interfaces
lxc file push ./conf/proxy/interfaces proxy/etc/network/interfaces


echo "Iniciando containers"
lxc start ssh
lxc start proxy
lxc start www1
lxc start www2
lxc start log
lxc start zabbix

echo "Aguardando 5 segundos para inicialização"
sleep 5
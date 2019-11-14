#!/bin/bash
# criando containers

#WEBSERVER
echo "Criando o container www1 e www2"
lxc copy debian9padrao www1
lxc copy debian9padrao www2

echo "Ligando interface eth0 na rede interna"
lxc network attach redeFWINTSRV www1 eth0
lxc network attach redeFWINTSRV  www2 eth0

echo "Copiando configuracao de rede www1 e www2"
lxc file push ./conf/www1/interfaces www1/etc/network/interfaces
lxc file push ./conf/www2/interfaces www2/etc/network/interfaces


#GERENCIAMENTO
echo "Criando o container syslog e zabbix"
lxc copy debian9padrao syslog
lxc copy debian9padrao zabbix

echo "Ligando interface eth0 na rede interna"
lxc network attach redeFWINTSRV syslog eth0
lxc network attach redeFWINTSRV zabbix eth0

echo "Copiando configuracao de rede syslog e zabbix"
lxc file push ./conf/syslog/interfaces syslog/etc/network/interfaces
lxc file push ./conf/zabbix/interfaces zabbix/etc/network/interfaces


#DMZ
echo "Criando o container ssh e proxy"
lxc copy debian9padrao ssh
lxc copy debian9padrao proxy

echo "Ligando interface eth0 na rede interna"
lxc network attach redeFWEXTDMZ ssh eth0
lxc network attach redeFWEXTDMZ proxy eth0

echo "Copiando configuracao de rede ssh e proxy"
lxc file push ./conf/ssh/interfaces ssh/etc/network/interfaces
lxc file push ./conf/proxy/interfaces proxy/etc/network/interfaces


echo "Iniciando containers"
lxc start ssh
lxc start proxy
lxc start www1
lxc start www2
lxc start syslog
lxc start zabbix

echo "Aguardando 5 segundos para inicialização"
sleep 5
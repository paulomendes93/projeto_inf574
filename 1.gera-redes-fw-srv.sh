#!/bin/bash
# gera redes "Bridge" e Firewall
#
#
echo "Criando redes "
lxc network create redeFWDMZ ipv4.address=192.168.0.100/24 ipv4.nat=true ipv4.dhcp=false
lxc network create redeFWSRV ipv4.address=10.10.10.100/24 ipv4.nat=true ipv4.dhcp=false

### firewall
echo "Criando firewall"
lxc copy debian9padrao firewall

echo "Copiando configuracoes"
lxc file push ./conf/firewall/interfaces firewall/etc/network/interfaces 
lxc file push ./conf/firewall/sysctl.conf firewall/etc/sysctl.conf
lxc file push ./conf/firewall/rc.local firewall/etc/rc.local
lxc file push ./conf/firewall/sshd_config firewall/etc/ssh/sshd_config

echo "Ligando interfaces firewall"
lxc network attach lxdbr0 firewall eth0
lxc network attach redeFWDMZ firewall eth1
lxc network attach redeFWSRV firewall eth2


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

### Iniciando
echo "Iniciando containers"
lxc start firewall
lxc start ssh
lxc start proxy
lxc start www1
lxc start www2
lxc start log
lxc start zabbix

echo "Aguardando 5 segundos para inicialização"
sleep 5

echo "Setando NAT entre redeDWDMZ e eth0"
lxc exec firewall -- iptables -t nat -A POSTROUTING --source 192.168.0.0/24 --out-interface eth0 -j MASQUERADE
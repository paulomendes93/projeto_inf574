#!/bin/bash
# gera redes "Bridge" e Firewall
#
#
echo "Criando redes "
lxc network create redeFWDMZ ipv4.address=192.168.0.100/24 ipv4.nat=false ipv4.dhcp=false
lxc network create redeFWSRV ipv4.address=10.10.10.100/24 ipv4.nat=false ipv4.dhcp=false

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
lxc network attach redeFWDSRV firewall eth2

### Iniciando
echo "Iniciando containers"
lxc start firewall

echo "Aguardando 10 segundos para garantir que firewall esta no ar"
sleep 10

echo "Setando NAT entre redeDWDMZ e eth0"
lxc exec firewall -- iptables -t nat -A POSTROUTING --source 192.168.0.0/24 --out-interface eth0 -j MASQUERADE
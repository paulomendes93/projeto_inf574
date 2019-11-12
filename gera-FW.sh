#!/bin/bash
# gera o ambiente
#
#
echo "Criando redes "
lxc network create redeFW_WEB ipv4.address=10.0.0.1/27 ipv4.nat=false ipv4.dhcp=false
lxc network create redeFW_SERVERS ipv4.address=192.168.0.1/27 ipv4.nat=false ipv4.dhcp=false
lxc network create redeFW_DMZ ipv4.address=172.16.0.1/27 ipv4.nat=false ipv4.dhcp=false

### R
echo "Criando roteador R"
lxc copy debian9padrao R
echo "Ligando interfaces"
lxc network attach redeFW_WEB eth1
lxc network attach redeFW_SERVERS eth2
lxc network attach redeFW_DMZ eth3

echo "Copiando configuracoes"
lxc file push ./conf/R/interfaces R/etc/network/interfaces 
lxc file push ./conf/R/sysctl.conf R/etc/sysctl.conf
lxc file push ./conf/R/rc.local R/etc/rc.local
lxc file push ./conf/R/radvd.conf R/etc/radvd.conf

echo "Iniciando containers"
lxc start R
lxc start A1
lxc start A2
lxc start B1

echo "Aguardando 10 segundos para garantir que R esta no ar"
sleep 10
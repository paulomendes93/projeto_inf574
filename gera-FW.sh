#!/bin/bash
# gera o ambiente
#
#
echo "Criando redes "
lxc network create redeR_GW ipv4.address=10.19.70.100/24 ipv4.nat=true ipv4.dhcp=false
lxc network create redeFW_EXT_DMZ ipv4.address=192.168.0.100/24 ipv4.nat=true ipv4.dhcp=false
lxc network create redeFW_INT_SRV ipv4.address=10.10.10.100/24 ipv4.nat=true ipv4.dhcp=false

### FW_EXT
echo "Criando FW_EXT"
lxc copy debian9padrao FW_EXT

echo "Copiando configuracoes"
lxc file push ./conf/FW_EXT/interfaces FW_EXT/etc/network/interfaces 
lxc file push ./conf/FW_EXT/sysctl.conf FW_EXT/etc/sysctl.conf
lxc file push ./conf/FW_EXT/rc.local FW_EXT/etc/rc.local

echo "Ligando interfaces FW_EXT"
lxc network attach redeR_WEB FW_EXT eth0
lxc network attach redeFW_EXT_DMZ FW_EXT eth1

### FW_INT
echo "Criando FW_INT"
lxc copy debian9padrao FW_INT

echo "Copiando configuracoes"
lxc file push ./conf/FW_INT/interfaces FW_INT/etc/network/interfaces 
lxc file push ./conf/FW_INT/sysctl.conf FW_INT/etc/sysctl.conf
lxc file push ./conf/FW_INT/rc.local FW_INT/etc/rc.local

echo "Ligando interfaces FW_INT"
lxc network attach redeFW_EXT_DMZ FW_INT eth0
lxc network attach redeFW_INT_SRV FW_INT eth1

echo "Iniciando containers"
lxc start FW_EXT
lxc start FW_INT

echo "Aguardando 10 segundos para garantir que R esta no ar"
sleep 10
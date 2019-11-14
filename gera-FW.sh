#!/bin/bash
# gera o ambiente
#
#
echo "Criando redes "
lxc network create redeFWEXTDMZ ipv4.address=192.168.0.100/24 ipv4.nat=true ipv4.dhcp=false
lxc network create redeFWINTSRV ipv4.address=10.10.10.100/24 ipv4.nat=true ipv4.dhcp=false

### FWEXT
echo "Criando FWEXT"
lxc copy debian9padrao FWEXT

echo "Copiando configuracoes"
lxc file push ./conf/FWEXT/interfaces FWEXT/etc/network/interfaces 
lxc file push ./conf/FWEXT/sysctl.conf FWEXT/etc/sysctl.conf
lxc file push ./conf/FWEXT/rc.local FWEXT/etc/rc.local

echo "Ligando interfaces FWEXT"
lxc network attach redeFWEXTDMZ FWEXT eth1

### FWINT
echo "Criando FWINT"
lxc copy debian9padrao FWINT

echo "Copiando configuracoes"
lxc file push ./conf/FWINT/interfaces FWINT/etc/network/interfaces 
lxc file push ./conf/FWINT/sysctl.conf FWINT/etc/sysctl.conf
lxc file push ./conf/FWINT/rc.local FWINT/etc/rc.local

echo "Ligando interfaces FWINT"
lxc network attach redeFWEXTDMZ FWINT eth0
lxc network attach redeFWINTSRV FWINT eth1

echo "Iniciando containers"
lxc start FWEXT
lxc start FWINT

echo "Aguardando 10 segundos para garantir que R esta no ar"
sleep 10
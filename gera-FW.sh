#!/bin/bash
# gera o ambiente
#
#
echo "Criando redes "
lxc network create redeFW_WEB ipv4.address=10.0.0.100/24 ipv4.nat=true ipv4.dhcp=false
lxc network create redeFW_SERVERS ipv4.address=172.16.0.100/24 ipv4.nat=true ipv4.dhcp=false
lxc network create redeFW_DMZ ipv4.address=192.168.0.100/24 ipv4.nat=true ipv4.dhcp=false

### R
echo "Criando roteador R"
lxc copy debian9padrao R

echo "Copiando configuracoes"
lxc file push ./conf/R/interfaces R/etc/network/interfaces 
lxc file push ./conf/R/sysctl.conf R/etc/sysctl.conf
lxc file push ./conf/R/rc.local R/etc/rc.local
lxc file push ./conf/R/radvd.conf R/etc/radvd.conf

echo "Ligando interfaces"
lxc network attach redeFW_WEB R eth1
lxc network attach redeFW_SERVERS R eth2
lxc network attach redeFW_DMZ R eth3

echo "Iniciando containers"
lxc start R

echo "Aguardando 10 segundos para garantir que R esta no ar"
sleep 10

echo "Configurando rotas (em teste)"

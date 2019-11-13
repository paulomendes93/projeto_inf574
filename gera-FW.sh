#!/bin/bash
# gera o ambiente
#
#
echo "Criando redes "
lxc network create redeFW_WEB
lxc network create redeFW_SERVERS
lxc network create redeFW_DMZ

### R
echo "Criando roteador R"
lxc copy debian9padrao R
echo "Ligando interfaces"
lxc network attach redeFW_WEB R eth1
lxc network attach redeFW_SERVERS R eth2
lxc network attach redeFW_DMZ R eth3

echo "Copiando configuracoes"
lxc file push ./conf/R/interfaces R/etc/network/interfaces 
lxc file push ./conf/R/sysctl.conf R/etc/sysctl.conf
lxc file push ./conf/R/rc.local R/etc/rc.local
lxc file push ./conf/R/radvd.conf R/etc/radvd.conf

echo "Iniciando containers"
lxc start R

echo "Aguardando 10 segundos para garantir que R esta no ar"
sleep 10
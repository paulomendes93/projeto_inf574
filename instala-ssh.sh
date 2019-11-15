#!/bin/bash
# instala ssh server nas maquinas e tambem fail2ban e autenticacao de 2 fatores

echo "Instalando pacotes no container SSH"
lxc exec ssh -- /usr/bin/apt install -y openssh-server fail2ban libpam-google-authenticator

echo "Copiando arquivos de configuracao"
lxc file push conf/ssh/sshd_config ssh/etc/ssh/sshd_config -p --uid 0 --gid 0 --mode 0644
lxc file push conf/ssh/sshd ssh/etc/pam.d/sshd -p --uid 0 --gid 0 --mode 0644  

echo "Reiniciando sshd"
lxc exec ssh -- service sshd restart

echo "fim"

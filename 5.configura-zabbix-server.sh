#!/bin/bash
# documentacao de referencia: https://www.zabbix.com/documentation/4.4/manual
#
# gera maquina zabbix
#
echo "Copiando sources.list com repositorios non-free"
lxc file push ./conf/zabbix/sources.list zabbix/etc/apt/sources.list --mode 0755

echo "Atualizando pacotes e instalando wget"
lxc exec zabbix -- /usr/bin/apt update
lxc exec zabbix -- /usr/bin/apt upgrade -y
lxc exec zabbix -- /usr/bin/apt install -y wget

echo "Adicionando repositorio zabbix 4.4"
lxc exec zabbix -- wget https://repo.zabbix.com/zabbix/4.4/debian/pool/main/z/zabbix-release/zabbix-release_4.4-1+stretch_all.deb
lxc exec zabbix -- dpkg -i zabbix-release_4.4-1+stretch_all.deb
lxc exec zabbix -- rm zabbix-release_4.4-1+stretch_all.deb
lxc exec zabbix -- /usr/bin/apt update

echo ""
echo "Pressione ENTER para continuar..."
read

echo "Instalando zabbix server"
lxc exec zabbix -- /usr/bin/apt install -y zabbix-server-mysql

echo "Copiando o arquivo de configuracao zabbix_server.conf"
lxc file push ./conf/zabbix/zabbix_server.conf zabbix/etc/zabbix/zabbix_server.conf --mode 0644

echo "Instalando frontend do zabbix"
lxc exec zabbix -- /usr/bin/apt install -y zabbix-frontend-php zabbix-apache-conf

echo "Copiando o arquivo de configuracao php.ini"
lxc file push ./conf/zabbix/php.ini zabbix/etc/php/7.0/apache2/php.ini --mode 0644

echo "Copiando o arquivo configura-db.sh"
lxc file push ./conf/zabbix/configura-db.sh zabbix/root/configura-db.sh --mode 0755

echo ""
echo "Pressione ENTER para continuar..."
read

echo "Setting up Zabbix Database"
lxc exec zabbix -- /root/configura-db.sh

echo ""
echo "Database criado! Pressione ENTER para seguir..."
read		
			
echo "Instalando o agente zabbix no servidor"
lxc exec zabbix -- /usr/bin/apt install -y zabbix-agent

echo "Enabling zabbix-agent on startup"
lxc exec zabbix -- update-rc.d zabbix-agent enable
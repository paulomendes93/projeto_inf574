#!/bin/bash
#
echo "Criando o database para o zabbix e preparando o database zabbix com o schema do zabbix-server"
echo "create database zabbix character set utf8 collate utf8_bin;" | mysql
echo "grant all privileges on zabbix.* to zabbix@localhost identified by 'inf500';" | mysql 
apt-get install zabbix-server-mysql zabbix-frontend-php zabbix-agent 
#zcat /usr/share/doc/zabbix-server-mysql/create.sql.gz | mysql -uzabbix -pinf500 zabbix

mysql -u root -p
create database zabbix character set utf8 collate utf8_bin;
grant all privileges on zabbix.* to zabbix@localhost identified by '123456';
update-rc.d zabbix-server enable
update-rc.d apache2 enable
quit;

cd /usr/share/doc/zabbix-server-mysql/ 
zcat create.sql.gz | mysql -u zabbix -p zabbix 


service zabbix-server start
service apache2 restart

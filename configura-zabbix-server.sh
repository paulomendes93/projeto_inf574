#!/bin/bash
#
echo "Criando o database para o zabbix e preparando o database zabbix com o schema do zabbix-server"
echo "create database zabbix character set utf8 collate utf8_bin;" | mysql
echo "grant all privileges on zabbix.* to zabbix@localhost identified by 'inf500';" | mysql 
apt-get install zabbix-server-mysql zabbix-frontend-php zabbix-agent 
mysql -u root -p

create database zabbix character set utf8 collate utf8_bin;
grant all privileges on zabbix.* to zabbix@localhost identified by '123456';
mysql> quit;

sudo cd /usr/share/doc/zabbix-server-mysql
sudo zcat create.sql.gz | mysql -uzabbix -p zabbix
update-rc.d apache2 enable
quit;

DBHost=localhost 
DBName=zabbix 
DBUser=zabbix 
DBPassword=123456

sudo systemctl restart zabbix-server
sudo systemctl restart zabbix-agent
sudo systemctl enable zabbix-server
sudo systemctl enable zabbix-agent

php_value date.timezone America/Sao_Paulo
sudo service apache2 restart

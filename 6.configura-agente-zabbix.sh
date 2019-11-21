#!/bin/bash
# instala o agente zabbix  nas maquinas 
for maq in firewall ssh proxy www1 www2 zabbix log
do
    echo "Atualizando pacotes e instalando wget no container " $maq
    lxc exec $maq -- /usr/bin/apt update
    lxc exec $maq -- /usr/bin/apt upgrade -y
    lxc exec $maq -- /usr/bin/apt install -y wget

    echo "Adicionando repositorio zabbix 4.4 no container " $maq
    #lxc exec $maq -- wget https://repo.zabbix.com/zabbix/4.4/debian/pool/main/z/zabbix-release/zabbix-release_4.4-1+stretch_all.deb
	lxc file push ./conf/zabbix/zabbix-release_4.4-1+stretch_all.deb $maq/tmp/
	#lxc exec $maq -- dpkg -i zabbix-release_4.4-1+stretch_all.deb
	lxc exec $maq -- dpkg -i /tmp/zabbix-release_4.4-1+stretch_all.deb

    #lxc exec $maq -- rm zabbix-release_4.4-1+stretch_all.deb
    lxc exec $maq -- /usr/bin/apt update

    echo "Instalando agente zabbix no container " $maq
    lxc exec $maq --  /usr/bin/apt install -y zabbix-agent

    echo "Habilitando agente zabbix para inicilizar automaticamente no container " $maq
    lxc exec $maq --  update-rc.d zabbix-agent enable

    echo "Copiando o arquivo de configuracao zabbix_server.conf"
    lxc file push ./conf/zabbix/zabbix_agentd.conf $maq/etc/zabbix/zabbix_agentd.conf --mode 0644

    echo "Iniciando agente zabbix no container " $maq
    lxc exec $maq -- service zabbix-agent start
    echo "fim"
done

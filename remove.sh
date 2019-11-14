#!/bin/bash
# remove o primeiro ambiente:
# as duas maquinas e a rede
echo "Parando as maquinas"
lxc exec FWEXT -- /sbin/poweroff
lxc exec FWINT -- /sbin/poweroff
lxc exec ssh -- /sbin/poweroff
lxc exec proxy -- /sbin/poweroff
lxc exec www1 -- /sbin/poweroff
lxc exec www2 -- /sbin/poweroff
lxc exec syslog -- /sbin/poweroff
lxc exec zabbix -- /sbin/poweroff


echo "Aguardando 5 segundos para remover"
sleep 5

echo "Removendo maquinas"
lxc delete FWEXT
lxc delete FWINT
lxc delete ssh
lxc delete proxy
lxc delete www1
lxc delete www2
lxc delete syslog
lxc delete zabbix

echo "Removendo as redes"
lxc network delete redeFWEXTGW 
lxc network delete redeFWEXTDMZ
lxc network delete redeFWINTSRV

echo "Removendo o redirecionamento"
lxc config device remove www1 myport8081
lxc config device remove www2 myport8082

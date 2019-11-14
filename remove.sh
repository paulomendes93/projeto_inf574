#!/bin/bash
# remove o primeiro ambiente:
# as duas maquinas e a rede
echo "Parando a maquinas"
lxc exec FW_EXT -- /sbin/poweroff
lxc exec FW_INT -- /sbin/poweroff
lxc exec www1 -- /sbin/poweroff
lxc exec www2 -- /sbin/poweroff

echo "Aguardando 5 segundos para remover"
sleep 5

echo "Removendo maquinas"
lxc delete FW_EXT
lxc delete FW_INT
lxc delete www1
lxc delete www2


echo "Removendo as  redes"
lxc network delete redeR_GW
lxc network delete redeFW_EXT_DMZ
lxc network delete redeFW_INT_SRV


echo "Removendo a o redirecionamento"
lxc config device remove www1 myport8081
lxc config device remove www2 myport8082

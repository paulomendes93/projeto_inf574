#!/bin/bash
# remove o primeiro ambiente:
# as duas maquinas e a rede
echo "Parando a maquinas"
lxc exec FWEXT -- /sbin/poweroff
lxc exec FWINT -- /sbin/poweroff
lxc exec www1 -- /sbin/poweroff
lxc exec www2 -- /sbin/poweroff

echo "Aguardando 5 segundos para remover"
sleep 5

echo "Removendo maquinas"
lxc delete FWEXT
lxc delete FWINT
lxc delete www1
lxc delete www2


echo "Removendo as  redes"
lxc network delete redeFWEXTGW 
lxc network delete redeFWEXTDMZ
lxc network delete redeFWINTSRV


echo "Removendo a o redirecionamento"
lxc config device remove www1 myport8081
lxc config device remove www2 myport8082

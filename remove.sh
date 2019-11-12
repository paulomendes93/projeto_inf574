#!/bin/bash
# remove o primeiro ambiente:
# as duas maquinas e a rede
echo "Parando a maquinas"
lxc exec R -- /sbin/poweroff
lxc exec www1 -- /sbin/poweroff
lxc exec www2 -- /sbin/poweroff

echo "Aguardando 5 segundos para remover"
sleep 5

echo "Removendo maquinas"
lxc delete R
lxc delete www1
lxc delete www2


echo "Removendo as  redes"
lxc network delete redeFW_WEB
lxc network delete redeFW_SERVERS
lxc network delete redeFW_DMZ


echo "Removendo a o redirecionamento"
lxc config device remove www1 myport8081
lxc config device remove www2 myport8082

#!/bin/bash
#
### Proxy
	echo "Instalando e configurando $maq"
	lxc exec proxy -- apt update
	lxc exec proxy -- apt upgrade -y
	lxc exec proxy -- apt install -y nginx
done


###
# redirecionando a porta 8080 e 8081 para o servidor na porta 80 no container www1 e www2
#lxc config device add proxy myport8080 proxy listen=tcp:0.0.0.0:80 connect=tcp:192.168.0.103:80
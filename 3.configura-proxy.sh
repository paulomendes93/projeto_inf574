#!/bin/bash
#
### Proxy
	echo "Instalando e configurando proxy"
	lxc exec proxy -- apt update
	lxc exec proxy -- apt upgrade -y
	lxc exec proxy -- apt install -y nginx
	
	lxc file push ./conf/proxy/default proxy/etc/nginx/sites-enabled/
done

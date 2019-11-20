#!/bin/bash
#
### Proxy
	echo "Instalando Proxy - NGINX"
	lxc exec proxy -- apt update
	lxc exec proxy -- apt upgrade -y
	lxc exec proxy -- apt install -y nginx
	
	echo "Configurando Proxy"
	lxc file push ./conf/proxy/default proxy/etc/nginx/sites-enabled/
	
	echo "reiniciando servico Ngix"
	lxc exec proxy -- systemctl restart nginx
done

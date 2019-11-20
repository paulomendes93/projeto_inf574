#!/bin/bash
# instala ssh server nas maquinas e tambem fail2ban e autenticacao de 2 fatores

echo "Instalando pacotes no container SSH"
lxc exec ssh -- /usr/bin/apt install -y openssh-server fail2ban libpam-google-authenticator


            echo ""
            echo "Setting up user with password"
            lxc exec ssh -- userdel ssh_user
            lxc exec ssh -- adduser ssh_user

            echo ""
            echo "Setting up SSH alias"
            echo "./conf/ssh/.bashrc    --->   ssh/root/.bashrc"
            lxc file push ./conf/ssh/.bashrc ssh/root/.bashrc
            echo "./conf/ssh/.bashrc    --->   ssh/home/ssh_user/.bashrc.alias"
            lxc file push ./conf/ssh/.bashrc ssh/home/ssh_user/
            lxc exec ssh -- cat ssh/home/ssh_user/.bashrc.alias >> ssh/home/ssh_user/.bashrc


            echo ""
            echo "Setting up fail2ban"
            echo "./conf/ssh/jail.local    --->   ssh/etc/fail2ban/"
            lxc file push ./conf/ssh/jail.local ssh/etc/fail2ban/
            echo "./conf/ssh/fail2ban.local    --->   ssh/etc/fail2ban/"
            lxc file push ./conf/ssh/fail2ban.local ssh/etc/fail2ban/
            echo "Setting up fail2ban logfile ownership"
            lxc exec ssh -- chown ssh_user:ssh_user /var/log/fail2ban.log
            echo "Restarting fail2ban service"
            lxc exec ssh -- service fail2ban restart			
			

echo "Copiando arquivos de configuracao"
#lxc file push conf/ssh/sshd_config 	ssh/etc/ssh/sshd_config -p --uid 0 --gid 0 --mode 0644
#lxc file push conf/ssh/sshd 		ssh/etc/pam.d/sshd -p --uid 0 --gid 0 --mode 0644  

echo "Reiniciando sshd"
lxc exec ssh -- service sshd restart



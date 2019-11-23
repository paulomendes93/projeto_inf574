
# SSH Alias - Network DMZ
alias ssh-ssh='ssh -i /ssh_user/.ssh/ssh_ssh_key ssh_user@192.168.0.102'
alias ssh-proxy='ssh -i /ssh_user/.ssh/ssh_ssh_key proxy_user@192.168.0.103'

# SSH Alias - Network SERVERS
alias ssh-www1='ssh -i /ssh_user/.ssh/ssh_ssh_key www1_user@10.10.10.10'
alias ssh-www2='ssh -i /ssh_user/.ssh/ssh_ssh_key www2_user@10.10.10.11'
alias ssh-log='ssh -i /ssh_user/.ssh/ssh_ssh_key log_user@10.10.10.12'
alias ssh-zabbix='ssh -i /ssh_user/.ssh/ssh_ssh_key zabbix_user@10.10.10.13'

# fail2ban
alias log-fail2ban='tail -f /var/log/fail2ban.log'

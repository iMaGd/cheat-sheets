#!/bin/bash

sudo apt install fail2ban -y
sudo systemctl start fail2ban


# Write the configuration to /etc/fail2ban/jail.d/override.local
sudo tee /etc/fail2ban/jail.d/override.local > /dev/null << 'EOF'
[DEFAULT]
bantime = 10m
findtime = 10m
maxretry = 5
backend = auto
usedns = warn
logencoding = auto

[sshd]
enabled = true
port = ssh
filter = sshd
logpath = %(sshd_log)s
maxretry = 3
EOF

# Restart fail2ban service to apply the changes
sudo systemctl restart fail2ban

# Check the status of a all jails:
sudo fail2ban-client status
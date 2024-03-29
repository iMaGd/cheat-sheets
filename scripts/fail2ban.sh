#!/bin/bash

sudo apt install fail2ban -y
sudo systemctl start fail2ban


# Write the configuration to /etc/fail2ban/jail.d/override.local
sudo tee /etc/fail2ban/jail.d/override.local > /dev/null << 'EOF'
[DEFAULT]
bantime = 10m
findtime = 10m
maxretry = 6

[sshd]
enabled = true
bantime = 30m
maxretry = 3
EOF

# Check config file
echo "--------------------"
echo -e "Config added to new config file:\n "
echo -e "-> /etc/fail2ban/jail.d/override.local \n "
sudo cat /etc/fail2ban/jail.d/override.local
echo -e "--------------------\n"

# Restart fail2ban service to apply the changes
echo -e "Restarting the service .. (takes time, be patient!)\n"
sudo systemctl restart fail2ban


echo "Fail2Ban service status: "
# Check service staus
sudo systemctl status fail2ban

# Check the status of a all jails:
sudo fail2ban-client status

# Display logs generated by the Fail2Ban service
sudo journalctl -u fail2ban
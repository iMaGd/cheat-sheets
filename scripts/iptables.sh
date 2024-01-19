#!/bin/bash

prompt_yes_no() {
    while true; do
        # Ask the user
        read -rp "$1 [Y/n]: " answer

        # Default to Yes if no answer is given.
        if [[ -z $answer ]]; then
            answer="N"
        fi

        # Check the answer
        case "$answer" in
            [Yy]* ) return 0;;
            [Nn]* ) return 1;;
            * ) echo "Please answer yes or no.";;
        esac
    done
}


if prompt_yes_no "Disable UFW?"; then
    sudo ufw app list
    sudo ufw disable
    sudo systemctl stop ufw
    sudo systemctl mask ufw
    sudo ufw reset -y
fi

if prompt_yes_no "Remove UFW?"; then
    sudo apt remove --purge ufw -y
fi

echo -e "Init iptables: .. \n";
sudo apt install iptables -y
sudo service iptables start

echo -e "Installing iptables-persistent .. \n";
sudo apt install iptables-persistent -y

echo -e "Current iptables rules: .. \n";
sudo iptables -L -v

if prompt_yes_no "Flush rules and start with a clean set of rules?!"; then
	sudo iptables -F
fi

# Ensure any traffic that isn't explicitly allowed is denied
sudo iptables -P INPUT DROP
sudo iptables -P FORWARD DROP
sudo iptables -P OUTPUT ACCEPT

# Allow local loopback traffic
sudo iptables -A INPUT -i lo -j ACCEPT
sudo iptables -A OUTPUT -o lo -j ACCEPT

# Allow established and related connections
sudo iptables -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT

# Allow incoming ICMP echo requests
sudo iptables -A INPUT -p icmp --icmp-type echo-request -m conntrack --ctstate NEW,ESTABLISHED -m limit --limit 1/s -j ACCEPT

# Allow SSH
sudo iptables -A INPUT -p tcp --dport 22 -j ACCEPT

# Allow HTTP and HTTPS
sudo iptables -A INPUT -p tcp --dport 80 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 443 -j ACCEPT

# Allow for custom docker ports
sudo iptables -A INPUT -p tcp --match multiport --dports 7000:7999 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT

# Mitigate SYN flood attack
sudo iptables -A INPUT -p tcp ! --syn -m state --state NEW -j DROP
sudo iptables -A INPUT -p tcp --tcp-flags ALL NONE -j DROP
sudo iptables -A INPUT -p tcp --tcp-flags ALL ALL -j DROP

# No direct access to the MySQL or MariaDB port
sudo iptables -A INPUT -p tcp --dport 3306 -j ACCEPT
# sudo iptables -A INPUT -p tcp --dport 3306 -s 0.0.0.0 -j ACCEPT

# Prevent port scanning
sudo iptables -N port-scanning
sudo iptables -A port-scanning -p tcp --tcp-flags SYN,ACK,FIN,RST RST -m limit --limit 1/s --limit-burst 2 -j RETURN
sudo iptables -A port-scanning -j DROP

sudo iptables -A INPUT -j DROP
sudo iptables -A INPUT -j DROP

# Allow all connections for an ip
# sudo iptables -I INPUT 9 -p tcp -s XXX.XXX.XXX.XXX -j ACCEPT

# check again
sudo iptables -L -v

# Save rules
sudo netfilter-persistent save

# Restart iptables to apply the rules
sudo systemctl restart netfilter-persistent

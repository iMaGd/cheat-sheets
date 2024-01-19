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
	sudo ufw disable
	sudo systemctl stop ufw
	sudo systemctl mask ufw
	sudo ufw reset
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

# start seting rules
sudo iptables -P INPUT DROP
sudo iptables -P FORWARD DROP
sudo iptables -P OUTPUT ACCEPT

# Allow local loopback traffic
sudo iptables -A INPUT -i lo -j ACCEPT
# Allow established and related connections
sudo iptables -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
# Allow SSH
sudo iptables -A INPUT -p tcp --dport 22 -j ACCEPT

# Allow HTTP and HTTPS
sudo iptables -A INPUT -p tcp --dport 80 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 443 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 2027 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 3306 -j ACCEPT
sudo iptables -A INPUT -p tcp -m tcp --dport 5900 -j ACCEPT
sudo iptables -A INPUT -p tcp -m tcp --dport 5901 -j ACCEPT

sudo iptables -A INPUT -s 192.168.1.0/24 -p udp -m udp --dport 137 -j ACCEPT
sudo iptables -A INPUT -s 192.168.1.0/24 -p udp -m udp --dport 138 -j ACCEPT
sudo iptables -A INPUT -s 192.168.1.0/24 -p tcp -m tcp --dport 139 -j ACCEPT
sudo iptables -A INPUT -s 192.168.1.0/24 -p tcp -m tcp --dport 445 -j ACCEPT

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

> **Note**: Both `ufw` and `iptables` essentially interact with the same backend (the `netfilter` kernel subsystem), so the underlying functionality is the same. `ufw` is considered a front-end for `iptables` and simplifies much of the process of configuring it.

### Install

check if iptables is installed
   ```bash
	sudo iptables -L -v
	sudo apt install iptables
	sudo service iptables start
   ```

   Disable ufw
   ```bash
	sudo ufw app list
   sudo ufw disable
   sudo systemctl stop ufw
   sudo systemctl mask ufw
   sudo ufw reset -y
   sudo apt remove --purge ufw -y
   ```

To save and reload your iptables rules on system reboot, you can use the `iptables-persistent` package.

Install it with the following command:

   ```bash
   sudo apt install iptables-persistent
   ```

During installation, you might be asked if you want to save your current rules. You can choose to do so if you've already added rules, or you can save them later.

### Add Common Rules

It's a good idea to start with a clean set of rules. You can flush the current rules with:

   ```bash
   sudo iptables -F
   ```

Run following commands to add each rule one by one

```bash
# Clear existing rules and set default policy
sudo iptables -F
sudo iptables -P INPUT DROP
sudo iptables -P FORWARD DROP
sudo iptables -P OUTPUT ACCEPT

# Allow local loopback traffic
sudo iptables -A INPUT -i lo -j ACCEPT
# Allow established and related connections
sudo iptables -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
# Allow SSH
sudo iptables -A INPUT -p tcp --dport 22 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 181 -j ACCEPT
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

sudo iptables -A INPUT -p icmp --icmp-type echo-request -j ACCEPT
sudo iptables -A INPUT -p tcp -s <application_server_ip> --dport 3306 -j ACCEPT
sudo iptables -A INPUT -j DROP
sudo iptables -A INPUT -j DROP

# check again
sudo iptables -L -v

# Maybe want to insert rules to a specific location
sudo iptables -I INPUT 8 -p icmp --icmp-type echo-request -j ACCEPT

# Allow all connections for an ip
sudo iptables -I INPUT 9 -p tcp -s XXX.XXX.XXX.XXX -j ACCEPT

sudo iptables -I INPUT 8 -p tcp -m tcp --dport 5901 -j ACCEPT
sudo iptables -I INPUT 8 -p tcp -m ucp --dport 5900 -j ACCEPT

# Save rules
sudo netfilter-persistent save

# Restart iptables to apply the rules
sudo systemctl restart netfilter-persistent
```

### Flush & allow all traffics:

```bash
sudo iptables -F
sudo iptables -X
sudo iptables -t nat -F
sudo iptables -t nat -X

sudo iptables -P INPUT ACCEPT
sudo iptables -P FORWARD ACCEPT
sudo iptables -P OUTPUT ACCEPT
```

Store and restart
```bash
# Save rules
sudo netfilter-persistent save

# Restart iptables to apply the rules
sudo systemctl restart netfilter-persistent
service iptables restart
```

`-F` clears all rules.

`-X` removes any user-defined chains.

`-P` ACCEPT sets the default policy to allow all traffic.

Now the firewall won’t block anything.


### Edit SSH config file

[Config SSH](sshd.md)

### Config fail2ban

[Install and config fail2Ban](fail2ban.md)

### Disable UFW

[Disable UFW](ufw.md)

### Config Firewall by IPtables

[Config IPtables](iptables.md)

### Change server name

in `/etc/apache2/conf-available/security.conf` change
```ini
ServerTokens Full
SecServerSignature YourServerName
```


## User Management

COMMAND | DESCRIPTION
---|---
`sudo adduser username` | Create a new user
`sudo userdel username` | Delete a user
`sudo usermod -aG groupname username` | Add a user to group
`sudo deluser username groupname` | Remove a user from a group
`su - username` | Switch to a User
`awk -F':' '{ if ($3 >= 1000) print $1 }' /etc/passwd` | Get List of All Users

## SSH User

Restrict the client by setting their user shell to `/bin/true`

```bash
useradd sshtunnel -m -d /home/sshtunnel -s /bin/true
passwd sshtunnel

chmod 555 /home/sshtunnel/
cd /home/sshtunnel/
chmod 444 .bash_logout .bashrc .profile
```

To connect:
```bash
ssh -D 2000 -C -N sshtunnel@host -p 80
```



/etc/ssh/sshd_config.d/*.conf

```bash
sudo nano /etc/ssh/sshd_config.d/override.conf
```

```config
# Do not allow root logins via SSH
PermitRootLogin yes

# Disallow SSH protocol 1, which is less secure
Protocol 2

# Only allow specific users to SSH to the server
# AllowUsers your_username another_username

# Use key-based authentication and disallow password authentication
PubkeyAuthentication yes

# Use strong Ciphers
Ciphers aes256-ctr,aes192-ctr,aes128-ctr

# Do not read the user's ~/.rhosts and ~/.shosts files
HostbasedAuthentication no

# Disable empty passwords globally
PermitEmptyPasswords no

# Disable password-based authentication
PasswordAuthentication no

# Log more data (you can opt for VERBOSE for even more detailed logging)
LogLevel INFO

# Specify the location of the authorized_keys file
AuthorizedKeysFile .ssh/authorized_keys
```

Test the SSH configuration for any errors:

```bash
sudo sshd -t
```

If the configuration test passes without any error, restart the SSH daemon to apply the new settings:

```bash
sudo service ssh restart
```

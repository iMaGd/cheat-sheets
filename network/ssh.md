
# Summary
- Copy your public key `cat ~/.ssh/id_rsa.pub`
- Add it to `~/.ssh/authorized_keys` file on remote machine
- Restart the ssh server

### Create the RSA Key Pair
`ssh-keygen -t rsa`

### To place the public key on the virtual server
ssh-copy-id -i ~/.ssh/id_rsa.pub user@123.45.56.78

### Alternative:
```shell
cat ~/.ssh/id_rsa.pub | ssh user@123.45.56.78 "mkdir -p ~/.ssh && cat >>  ~/.ssh/authorized_keys"

# OR

cat ~/.ssh/id_rsa.pub | ssh username@remote_host -p 22 "mkdir -p ~/.ssh && touch ~/.ssh/authorized_keys && chmod 700 ~/.ssh &&
chmod 600 ~/.ssh/authorized_keys && cat >> ~/.ssh/authorized_keys"
```

### Descriptions
- Open `id_rsa.pub` and copy the content
- Login to using the same user in the rsync command
- Append the contents to `~/.ssh/authorized_keys`

### Important Note:
You are expected to copy your local public key to server "authorized_keys", dont create public and private keys on server too!

### Proper Permissions
```bash
chmod go-w /home/user
chmod 700 /home/user/.ssh
chmod 600 /home/user/.ssh/authorized_keys
```

-------

### Changing SSH Port
```bash
sudo nano /etc/ssh/sshd_config
```


## Full Grant for a User

### Without Asking for a Password:

To grant a user (i.e `adminuser`) the ability to run all commands without password:

1. Open the sudoers file with `visudo`:

   ```bash
   sudo visudo
   ```

2. Add the following lines at the end of the file to grant a user (i.e `adminuser`) the ability to run all commands without password:

   ```config
   adminuser ALL=(ALL) NOPASSWD: ALL
   ```

OR create a file specially for this user:

```sh
echo 'adminuser ALL=(ALL) NOPASSWD: ALL' | sudo tee /etc/sudoers.d/adminuser

sudo chmod 0440 /etc/sudoers.d/adminuser
```

### Asks for Password on SUDO commands

Simply add user to sudo group (asks for password for running sudo)

   ```bash
   sudo usermod -aG sudo adminuser
   ```


-----

## Full Grant a User for Certain Commands

To grant a specific user permission to run certain commands like reloading Apache or PHP-FPM without entering a password, follow below steps.

1. Open the sudoers file with `visudo`:

   ```bash
   sudo visudo
   ```

2. Add the following lines at the end of the file to grant the user `myuser` permission to run the specified commands without a password:

   ```bash
   myuser ALL=(ALL) NOPASSWD: /usr/sbin/service apache2 reload
   myuser ALL=(ALL) NOPASSWD: /usr/sbin/service php8.1-fpm reload
   ```

Or grant access for controlling all LEMP or LAMP services

   ```bash
   myuser ALL=(ALL) NOPASSWD: /usr/sbin/service apache2 *, /usr/sbin/service nginx *, /usr/sbin/service mysql *, /usr/sbin/service mariadb *
   myuser ALL=(ALL) NOPASSWD: /usr/sbin/service php*-fpm *

   myuser ALL=(ALL) NOPASSWD: /usr/bin/nano /var/www/*
   ```
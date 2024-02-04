## LAMP Boilerplate

```shell
apt update && apt upgrade -y

apt install -y \
  unzip zip nano openssh-server \
  curl wget axel \
  htop pv tree git nano pwgen \
  openssl certbot

# Disable ufw
sudo ufw app list
sudo ufw disable
sudo systemctl stop ufw
sudo systemctl mask ufw
sudo ufw reset -y
sudo apt remove --purge ufw -y

# Install Apache2
sudo apt install apache2 apache2-utils libapache2-mod-security2 python3-certbot-apache -y
sudo a2enmod rewrite headers ssl dir deflate expires block-xmlrpc proxy proxy_http

sudo a2dismod php
sudo a2dismod php7.4
sudo a2dismod php8.0
sudo a2dismod php8.1
sudo a2dismod mpm_prefork

sudo a2enmod mpm_event proxy_fcgi setenvif

service apache2 restart

# PHP & PHP-FPM install
apt install software-properties-common && add-apt-repository ppa:ondrej/php && sudo apt update

apt install php8.1-{cli,common,fpm,curl,bcmath,xml,dev,imap,mysql,zip,intl,gd,imagick,bz2,curl,mbstring,soap,cgi,redis,ssh2,yaml} -y


# Install Composer
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php composer-setup.php
sudo mv composer.phar /usr/local/bin/composer
composer --version

# Config php.ini
nano /etc/php/8.1/fpm/php.ini

upload_max_filesize = 32M
post_max_size = 32M
memory_limit = 256M
max_execution_time = 600
max_input_vars = 3000
max_input_time = 1000

nano /etc/php/8.1/fpm/pool.d/www.conf
# https://spot13.com/pmcalculator/


service apache2 restart
service php8.1-fpm restart

# SSL
sudo apt install -y openssl certbot python3-certbot-apache


chown -R www-data: /var/www

nano /etc/ssh/sshd_config

PubkeyAuthentication yes
PermitEmptyPasswords no
PasswordAuthentication no

create user 'pma'@'localhost' identified by 'password';
FLUSH PRIVILEGES;
```

### Fail2ban
```bash
apt install docker fail2ban -y
service fail2ban start
```
- https://webdock.io/en/docs/how-guides/security-guides/how-configure-fail2ban-common-services

### PHPMyAdmin
```bash
apt install phpmyadmin -y
```
- https://www.linuxbabe.com/ubuntu/install-phpmyadmin-apache-lamp-ubuntu-20-04


### SSL
```bash
sudo apt install -y openssl certbot python3-certbot-apache
```

# Image optimization (optional)
apt install pngquant jpegoptim
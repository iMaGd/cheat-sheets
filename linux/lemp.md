## LEMP Boilerplate

```shell
apt update && apt upgrade -y

apt install -y \
  unzip zip nano openssh-server \
  curl wget axel \
  htop pv tree git nano pwgen \
  openssl certbot


# PHP & PHP-FPM install
apt install software-properties-common && add-apt-repository ppa:ondrej/php && sudo apt update

apt install php8.1-{cli,common,fpm,curl,bcmath,xml,dev,imap,mysql,zip,intl,gd,imagick,bz2,curl,mbstring,soap,cgi,redis,ssh2,yaml} -y

apt install nginx -y

# Make sure the services are enabled and running
sudo systemctl enable php8.1-fpm
sudo systemctl enable nginx

sudo service php8.1-fpm start
sudo service nginx start

# Install Composer
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php composer-setup.php
sudo mv composer.phar /usr/local/bin/composer
composer --version

# Edit PHP ini
nano /etc/php/8.1/fpm/php.ini

upload_max_filesize = 32M
post_max_size = 48M
memory_limit = 256M
max_execution_time = 600
max_input_vars = 3000
max_input_time = 1000

# Edit PHP-FPM pool
nano /etc/php/8.1/fpm/pool.d/www.conf
# or make new pool
cp /etc/php/8.1/fpm/pool.d/www.conf /etc/php/8.1/fpm/pool.d/example.conf

### SSL
```bash
sudo apt install -y openssl certbot

# Install TSL Certificates
sudo certbot --nginx
```

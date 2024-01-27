#!/bin/bash

# Exit on error
set -e

# Enable mod_proxy_fcgi and setenvif modul
sudo a2enmod rewrite proxy_fcgi setenvif
sudo service apache2 restart

# Ask for domain names
read -p "Enter the domain name for new site (e.g., www.example.com): " new_domain

# Ask for document root with default value
read -p "Enter the DocumentRoot for your new site [default: /var/www/html]: " site_path
site_path=${site_path:-/var/www/html}

# Ask for the PHP-FPM version to use
read -p "Enter the PHP-FPM version to use with Apache [default: 8.1]: " php_version
php_version=${php_version:-8.1}

# Construct the PHP-FPM socket path
php_fpm_socket="/var/run/php/php${php_version}-fpm.sock"

# Setup WordPress VirtualHost
echo "Configuring VirtualHost for new site..."
sudo tee /etc/apache2/sites-available/"$new_domain".conf > /dev/null << EOF
<VirtualHost *:80>
	ServerName $new_domain
	# ServerAlias www.${new_domain}

	DocumentRoot $site_path

	<Directory "$site_path">
        # Don't show directory index
        Options -Indexes +FollowSymLinks +MultiViews
        # Allow .htaccess files
		AllowOverride All
        # Allow web access to this directory
		Require all granted
	</Directory>
	<FilesMatch \.php$>
		# 2.4.10+ can proxy to unix socket
		SetHandler "proxy:unix:$php_fpm_socket|fcgi://localhost/"
	</FilesMatch>

	ErrorLog \${APACHE_LOG_DIR}/${new_domain}.error.log
    CustomLog \${APACHE_LOG_DIR}/${new_domain}.access.log combined
</VirtualHost>
EOF

# Enable new site
sudo a2ensite "$new_domain"

# Disable the default Apache site
echo "Disabling default Apache VirtualHost..."
sudo a2dissite 000-default.conf

sudo service apache2 reload

# Create the info.php file with phpinfo()
sudo mkdir -p $site_path
sudo bash -c "echo '<?php phpinfo(); ?>' > $site_path/info.php"

# Set appropriate permissions for the info.php file
sudo chown www-data:www-data "${site_path}/info.php"
sudo chmod 644 "${site_path}/info.php"

# Reload Apache to apply all the changes
echo "Reloading Apache..."
sudo service apache2 reload

echo "New virtual host file added at /etc/apache2/sites-available/${new_domain}.conf."
echo "New site is configured successfully."

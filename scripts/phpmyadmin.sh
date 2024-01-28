#!/bin/bash

# Set phpMyAdmin Alias
read -p "Enter PhpMyAdmin alias [Default: /pma]: " PMA_ALIAS
PMA_ALIAS=${PMA_ALIAS:-/pma}

# Prompt for PHP-FPM version
read -p "Enter your PHP-FPM version (e.g., 8.1, 8.2) [Default: 8.1]: " PHP_FPM_VERSION
PHP_FPM_VERSION=${PHP_FPM_VERSION:-8.1}

if systemctl is-active --quiet php${PHP_FPM_VERSION}-fpm.service; then
    echo "PHP-FPM ${PHP_FPM_VERSION} is installed and running."
else
    echo "PHP-FPM ${PHP_FPM_VERSION} is not installed or not running."
    echo "Please install PHP-FPM ${PHP_FPM_VERSION} and ensure it's running."
    exit 1
fi

# Check if phpMyAdmin is installed
if ! which phpmyadmin > /dev/null; then
    # Install phpMyAdmin
    echo "phpMyAdmin not found. Installing..."
    sudo apt update
    sudo apt install -y phpmyadmin

    # Detect the web server and configure phpMyAdmin ..
    if systemctl is-active --quiet apache2.service; then
        echo "Apache detected. Configuring phpMyAdmin..."

        # Configure Apache
        sudo tee /etc/apache2/conf-available/phpmyadmin.conf > /dev/null << EOF
Alias "${PMA_ALIAS}" "/usr/share/phpmyadmin"
<Directory "/usr/share/phpmyadmin">
    Options SymLinksIfOwnerMatch
    DirectoryIndex index.php
    Require all granted
</Directory>
EOF

        # Enable the phpMyAdmin configuration and reload Apache
        sudo a2enconf phpmyadmin.conf
        sudo systemctl reload apache2.service

    elif systemctl is-active --quiet nginx.service; then
        echo "Nginx detected. Configuring phpMyAdmin..."

        # Configure Nginx
        sudo tee /etc/nginx/conf.d/phpmyadmin.conf > /dev/null << EOF
location "${PMA_ALIAS}" {
    root /usr/share/;
    index index.php index.html index.htm;
    location ~ ^${PMA_ALIAS}/(.+\.php)$ {
        try_files \$uri =404;
        root /usr/share/;
        fastcgi_pass unix:/var/run/php/php${PHP_FPM_VERSION}-fpm.sock;
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
        include /etc/nginx/fastcgi_params;
    }
}
EOF

		# Reload Nginx to apply configuration
		sudo systemctl reload nginx.service
	else
		echo "No supported web server found. Apache or Nginx is expected."
		exit 1
	fi

	echo "phpMyAdmin installation and configuration completed."
else
	echo "phpMyAdmin is already installed."
fi

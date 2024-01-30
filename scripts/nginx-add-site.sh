#!/bin/bash

# Exit on error
set -e

# Ask for domain names
read -p "Enter the domain name for new site (e.g., www.example.com): " new_domain
read -p "Enter the name for new site (e.g., example_com): " site_name

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

sudo service nginx restart

conf_file="/etc/nginx/sites-available/${site_name}"

sudo tee "$conf_file" > /dev/null << EOF
server {
    listen 80;
    server_name $new_domain;
    root $site_path;

	add_header X-Frame-Options \"SAMEORIGIN\";
    add_header X-Content-Type-Options \"nosniff\";
    add_header X-XSS-Protection \"1; mode=block\";

    index index.php index.html;

	charset utf-8;

    location / {
        try_files \$uri \$uri/ /index.php?\$args;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/var/run/php/php${php_version}-fpm.sock;
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
        include fastcgi_params;
    }

    location ~ /\.(?!well-known).* {
        deny all;
    }
}
EOF

# Check config file
echo "--------------------"
echo -e "New conf file added at ${conf_file}.\n"
sudo cat ${conf_file}
echo -e "--------------------\n"


# Enable the configuration by creating symlinks
sudo ln -s /etc/nginx/sites-available/$site_name /etc/nginx/sites-enabled/

# Check Nginx configuration for syntax errors
sudo nginx -t

# Reload to apply changes
sudo systemctl reload nginx

echo "Nginx has been installed and configured for new site."
#!/bin/bash

# Exit on error
set -e

# Ask for domain names
read -p "Enter the domain name for new site (e.g., www.example.com): " new_domain
read -p "Enter the name for new site (e.g., example-com): " site_name
read -p "Enter the user of new site (e.g., example-com): " site_user

# Ask for document root with default value
read -p "Enter the DocumentRoot for your new site [default: /home/${site_user}/www]: " site_path
site_path=${site_path:-/home/${site_user}/www}

# Ask for the PHP-FPM version to use
read -p "Enter the PHP-FPM version to use with Nginx [default: 8.3]: " php_version
php_version=${php_version:-8.3}

# Construct the PHP-FPM socket path
php_fpm_socket="/var/run/php/php${php_version}-fpm.sock"
vhost_conf_file="/etc/nginx/sites-available/${site_name}"

# Function to prompt for y/n question
prompt_yes_no() {
    while true; do
        # Ask the user
        read -rp "$1 [Y/n]: " answer

        # Default to Yes if no answer is given.
        if [[ -z $answer ]]; then
            answer="N"
        fi

        # Check the answer
        case "$answer" in
            [Yy]* ) return 0;;
            [Nn]* ) return 1;;
            * ) echo "Please answer yes or no.";;
        esac
    done
}

add_new_virtualhost() {
    echo "Configuring VirtualHost for new site..."
    sudo mkdir -p $site_path/public

    # Removing previous symbolic link
    sudo rm -f /etc/nginx/sites-enabled/${site_name}

    sudo tee "$vhost_conf_file" > /dev/null << EOF
server {
    listen 80;
    server_name $new_domain;
    root $site_path/public;

    add_header X-Frame-Options "SAMEORIGIN";
    add_header X-Content-Type-Options "nosniff";
    add_header X-XSS-Protection "1; mode=block";

    add_header Strict-Transport-Security 'max-age=31536000; includeSubDomains' always;
    # Add Referrer-Policy
    add_header Referrer-Policy 'no-referrer-when-downgrade';

    # Add Permissions-Policy
    # Disables geolocation and microphone access from all origins
    add_header Permissions-Policy 'geolocation=(), microphone=()';

    # Upgrade Insecure Requests
    add_header Content-Security-Policy 'upgrade-insecure-requests';

    index index.php index.html;

    charset utf-8;

    client_max_body_size 50M;

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

    # phpMyAdmin configurations
    location /pma {
        alias /usr/share/phpmyadmin/;
        try_files \$uri \$uri/ /pma/index.php\$is_args$args;

        location ~ ^/pma/(.+\.php)$ {
            try_files \$uri =404;
            fastcgi_pass unix:/var/run/php/php${php_version}-fpm.sock;
            fastcgi_index index.php;
            fastcgi_param SCRIPT_FILENAME \$request_filename;
            include fastcgi_params;
        }

        location ~* ^/pma/(.+\.(jpeg|jpg|png|css|gif|ico|js|html|xml|txt))$ {
            alias /usr/share/phpmyadmin/\$1;
        }
    }

    # add new configurations here
	error_log  /var/log/nginx/${site_name}_error.log;
    access_log /var/log/nginx/${site_name}_access.log;
}
EOF

    # Enable the configuration by creating symlinks
    sudo ln -s /etc/nginx/sites-available/$site_name /etc/nginx/sites-enabled/

    # Check config file
    echo "--------------------"
    echo -e "New conf file added at ${vhost_conf_file}\n"
    sudo cat ${vhost_conf_file}
    echo -e "--------------------\n"
}

# Check if the site configuration already exists
if [ -f "$vhost_conf_file" ]; then
	echo "A configuration file for this site already exists: ${vhost_conf_file}"

	if prompt_yes_no "Do you want to overwrite existing VirtualHost?!"; then
		add_new_virtualhost
	fi
else
	add_new_virtualhost
fi

# Reload to apply changes
sudo service nginx restart
sudo nginx -t

# Disable the default Nginx site
if prompt_yes_no "Disable default Nginx site?"; then
	# Disable the default site by removing the symbolic link
    sudo rm /etc/nginx/sites-enabled/default
	sudo service nginx reload
fi

# Create the info.php file with phpinfo()
if prompt_yes_no "Do you want to add a info.php file with phpinfo() in the new site directory?"; then
	sudo mkdir -p $site_path/public
	sudo bash -c "echo '<?php phpinfo(); ?>' > $site_path/public/info.php"
	sudo chmod 644 "${site_path}/public/info.php"
fi

# Check Nginx configuration for syntax errors
sudo nginx -t

# Reload to apply changes
sudo systemctl reload nginx


read -p "Enter the username: " site_user

pool_dir="/etc/php/${php_version}/fpm/pool.d"
pool_file="${pool_dir}/${site_user}.conf"

# Check if the PHP-FPM pool already exists
if [ -f "${pool_file}" ]; then
	echo "PHP-FPM pool configuration for user '${site_user}' already exists: ${pool_file}"
	exit 1
fi

# Create PHP-FPM pool configuration for the user
echo "Creating PHP-FPM pool for '${site_user}'..."
sudo bash -c "cat > ${pool_file} << EOF
[${site_user}]
user = ${site_user}
group = ${site_user}
listen = /var/run/php/php${php_version}-fpm-${site_user}.sock
listen.owner = ${site_user}
listen.group = ${site_user}
pm = dynamic
pm.max_children = 25
pm.start_servers = 8
pm.min_spare_servers = 8
pm.max_spare_servers = 15
chdir = /
security.limit_extensions = .php
php_admin_value[disable_functions] = exec,passthru,shell_exec,system
php_admin_flag[allow_url_fopen] = on
EOF"

# Check config file
echo "--------------------"
echo "New PHP-FPm pool file added at ${pool_file}."
sudo cat ${pool_file}
echo -e "--------------------\n"

# Restart to apply the configuration
echo "Restarting PHP-FPM..."
sudo service php${php_version}-fpm restart

# Update Nginx configuration to use the user's PHP-FPM pool
echo "Updating Nginx configuration for '${site_user}'..."
sudo sed -i "s|unix:/run/php/php${php_version}-fpm.sock|unix:/var/run/php/php${php_version}-fpm-${site_user}.sock|g" "${vhost_conf_file}"
sudo sed -i "s|unix:/var/run/php/php${php_version}-fpm.sock|unix:/var/run/php/php${php_version}-fpm-${site_user}.sock|g" "${vhost_conf_file}"

# Set appropriate permissions
sudo chown -R ${site_user}:${site_user} ${site_path}

# Since Apache/Nginx runs under the `www-data` user and requires only read access
# simply add `www-data` to the '${site_user}' group.
# This will enable `www-data` to read files owned by the '${site_user}' user
sudo usermod -aG ${site_user} www-data


# Check Nginx configuration for syntax errors
sudo nginx -t

# Reload to apply changes
sudo systemctl reload nginx

echo "Nginx has been installed and configured for new site."
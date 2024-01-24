#!/bin/bash

prompt_yes_no() {
    while true; do
        # Ask the user
        read -rp "$1 [y/n]: " answer

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

# Install WP-CLI
if prompt_yes_no "Do you want to install WP-CLI?"; then
    curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
	php wp-cli.phar --info
	chmod +x wp-cli.phar
	sudo mv wp-cli.phar /usr/local/bin/wp
	wp --info
fi


# Download WordPress core
if prompt_yes_no "Do you want to download WordPress core?"; then
    wp core download
    echo "WordPress core downloaded."
else
    echo "WordPress core download skipped."
fi


# Set up WordPress configuration
if prompt_yes_no "Setup WordPress configuration?"; then

read -p "Enter database name: " dbname
read -p "Enter database user: " dbuser
read -s -p "Enter database password: " dbpass
echo ""
read -p "Enter database host [localhost]: " dbhost
dbhost=${dbhost:-localhost}
read -p "Enter table prefix [wp_]: " dbprefix
dbprefix=${dbprefix:-wp_}
read -p "Do you want to enable WP_DEBUG? (y/n) " wp_debug

wp core config --dbname="$dbname" --dbuser="$dbuser" --dbpass="$dbpass" --dbhost="$dbhost" --dbprefix="$dbprefix" --extra-php <<PHP
define( 'WP_DEBUG', $( [[ "$wp_debug" == "y" ]] && echo 'true' || echo 'false' ) );
define( 'WP_DEBUG_LOG', $( [[ "$wp_debug" == "y" ]] && echo 'true' || echo 'false' ) );
PHP

# Create the database
wp db create

fi


# Install WordPress (multisite or single site)
if prompt_yes_no "Do you want to install a WordPress Multisite?"; then
    read -p "Enter URL for multisite: " site_url
    read -p "Enter WordPress Admin username: (admin)" admin_user
	admin_user=${admin_user:-admin}
	# Generate a strong password
	admin_pass=$(openssl rand -base64 12)

    wp core multisite-install --url="$site_url" --base=/ --title="Website" --admin_user="$admin_user" --admin_password="$admin_pass" --admin_email="admin@domain.com" --skip-email

	# Output the username and password
	echo "User '$admin_user' created with the password '$admin_pass'"

elif prompt_yes_no "or install a WordPress single site?"; then
	read -p "Enter URL for single site: " site_url
	read -p "Enter WordPress Admin username: (admin)" admin_user
	admin_user=${admin_user:-admin}
	# Generate a strong password
	admin_pass=$(openssl rand -base64 12)

    wp core install --url="$site_url" --title="Website" --admin_user="$admin_user" --admin_password="$admin_pass" --admin_email="admin@domain.com"
fi


# Enable SSL (search-replace)
if prompt_yes_no "Do you want to enable SSL?"; then
    wp search-replace "http://" "https://"
    echo "SSL enabled."
else
    echo "SSL enabling skipped."
fi

echo "WordPress setup completed."
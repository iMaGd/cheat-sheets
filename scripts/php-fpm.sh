#!/bin/bash


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


# List of php_version_choices
php_version_choices=("7.4" "8.0" "8.1" "8.2" "8.3" "Quit")

# Use the select command to create a menu
PS3="Select the version of PHP you would like to use: "
select selected_php_version in "${php_version_choices[@]}"; do

    # Check if the user wants to quit the script
    if [ "$selected_php_version" == "Quit" ]; then
        echo "Exiting script."
        exit 0
    fi

    # Validate that the user made a choice
    if [ -n "$selected_php_version" ]; then
        echo "You have selected PHP $selected_php_version"
        break
    else
        echo "Please select a valid option."
    fi
done


# Ask if php-fpm should be installed
if prompt_yes_no "Install PHP-FPM?"; then
	sudo apt install software-properties-common && sudo add-apt-repository ppa:ondrej/php && sudo apt update

	# Install PHP FPM and common extensions
    sudo apt install php${selected_php_version}-{cli,common,fpm,curl,bcmath,xml,xmlrpc,dev,imap,mysql,zip,intl,gd,imagick,bz2,curl,mbstring,soap,cgi,redis,ssh2,yaml,intl} -y

	# Install additional modules for Laravel or certain PHP apps
	sudo apt install php${selected_php_version}-{readline,ldap,pgsql,sqlite3,opcache} -y

	echo "PHP version $selected_php_version is successfully installed."
fi

# Run the installation command only if a PHP version was selected
if [ -n "$selected_php_version" ]; then

	# Install php-fpm if answer was 'yes'
	if prompt_yes_no "Do you want to optimize php.ini for PHP$selected_php_version-FPM?"; then

		# Following are recommneded config from [/php/php-fpm.md]

		memory_limit="512M"
		post_max_size="50M"
		upload_max_filesize="50M"
		max_execution_time="300"
		max_input_time="120"
		max_input_vars="2000"
		session_gc_maxlifetime="1440"
		opcache_enable="1"
		opcache_memory_consumption="192"
		opcache_max_accelerated_files="20000"
		opcache_validate_timestamps="1"
		realpath_cache_size="4096k"
		realpath_cache_ttl="600"

		PHP_INI="/etc/php/$selected_php_version/fpm/php.ini"

		# Update the php.ini file with the new values, creating backups with .bak extension
		sed_configs=(
			"s/^memory_limit = .*/memory_limit = $memory_limit/"
			"s/^post_max_size = .*/post_max_size = $post_max_size/"
			"s/^upload_max_filesize = .*/upload_max_filesize = $upload_max_filesize/"
			"s/^max_execution_time = .*/max_execution_time = $max_execution_time/"
			"s/^max_input_time = .*/max_input_time = $max_input_time/"
			"s/^max_input_vars = .*/max_input_vars = $max_input_vars/"
			"s/^;?session.gc_maxlifetime = .*/session.gc_maxlifetime = $session_gc_maxlifetime/"
			"s/^;?opcache.enable=.*$/opcache.enable=$opcache_enable/"
			"s/^;?opcache.memory_consumption=.*$/opcache.memory_consumption=$opcache_memory_consumption/"
			"s/^;?opcache.max_accelerated_files=.*$/opcache.max_accelerated_files=$opcache_max_accelerated_files/"
			"s/^;?opcache.validate_timestamps=.*$/opcache.validate_timestamps=$opcache_validate_timestamps/"
			"s/^;?realpath_cache_size = .*/realpath_cache_size = $realpath_cache_size/"
			"s/^;?realpath_cache_ttl = .*/realpath_cache_ttl = $realpath_cache_ttl/"
		)

		# Check if PHP version was selected and installed
		if [ -n "$selected_php_version" ]; then
			echo "Updating PHP ini settings for PHP $selected_php_version..."

			# Create a backup of the original php.ini file
			sudo cp "$PHP_INI"{,.bak}

			for config in "${sed_configs[@]}"; do
				sudo sed -i.bak -E "$config" "$PHP_INI"
			done

			echo "PHP ini settings for PHP $selected_php_version have been updated."

			# Restart PHP-FPM for the changes to take effect
			sudo systemctl restart php"$selected_php_version"-fpm

			echo "PHP$selected_php_version-FPM restarted."
		else
			echo "Skipped changing php.ini for version $selected_php_version."
		fi


	fi

else
    echo "No PHP version was selected to be installed."
fi

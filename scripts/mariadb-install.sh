#!/bin/bash

# Exit on error
set -e

# Check if run as root or with sudo
if [[ $(id -u) -ne 0 ]]; then
    echo "This script must be run as root or with sudo privileges!" >&2
    exit 1
fi

# Install MariaDB
install_mariadb() {
	echo "Starting MariaDB installation..."
	sudo apt update
	sudo apt install -y mariadb-server
	sudo systemctl start mariadb.service
	sudo systemctl enable mariadb.service
	echo "MariaDB installation completed."

	if prompt_yes_no "Secure MariaDB?"; then
		echo "Securing MariaDB Installation..."
		sudo mysql_secure_installation
		echo "MariaDB secured."
	fi

	if prompt_yes_no "Optimize MariaDB?"; then
		optimize_mariadb
	fi
}

# Optimize MariaDB
optimize_mariadb() {
	# Add basic optimizations to the MariaDB configuration
	echo "Optimizing MariaDB configuration..."
	local mariadb_config="/etc/mysql/mariadb.conf.d/50-server.cnf"

	# Find and set the path to the config based on your MariaDB installation
	if [ ! -f "$mariadb_config" ]; then
		mariadb_config="/etc/mysql/my.cnf"
		if [ ! -f "$mariadb_config" ]; then
			echo "Could not find MariaDB configuration file."
			return 1
		fi
	fi

	# Backup the configuration
	sudo cp "$mariadb_config" "$mariadb_config.bak"

	# Update the configuration settings
	sudo sed -i '/\[mysqld\]/a max_connections = 151' "$mariadb_config"
	sudo sed -i '/\[mysqld\]/a thread_cache_size = 8' "$mariadb_config"
	sudo sed -i '/\[mysqld\]/a query_cache_limit = 1M' "$mariadb_config"
	sudo sed -i '/\[mysqld\]/a query_cache_size = 16M' "$mariadb_config"
	sudo sed -i '/\[mysqld\]/a innodb_buffer_pool_size = 256M' "$mariadb_config"
	sudo sed -i '/\[mysqld\]/a innodb_log_file_size = 64M' "$mariadb_config"
	sudo sed -i '/\[mysqld\]/a innodb_log_buffer_size = 8M' "$mariadb_config"

	# Configuration for log files
	sudo sed -i '/\[mysqld\]/a expire_logs_days=60' "$mariadb_config"
	sudo sed -i '/\[mysqld\]/a max_binlog_size=1000M' "$mariadb_config" # Max binary log size
	sudo sed -i '/\[mysqld\]/a general_log=0' "$mariadb_config" # disables general query logging

	# Restart to apply changes
	sudo service mariadb restart

	echo "MariaDB configuration optimized."
}

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

install_mariadb

#!/bin/bash

# Exit on error
set -e

# Check if run as root or with sudo
if [[ $(id -u) -ne 0 ]]; then
    echo "This script must be run as root or with sudo privileges!" >&2
    exit 1
fi

# Install MySQL
install_mysql() {
	echo "Starting MySQL installation..."
	sudo apt update
	sudo apt install -y mysql-server
	sudo systemctl start mysql.service
	sudo systemctl enable mysql.service
	echo "MySQL installation completed."

	if prompt_yes_no "Secure MySQL?"; then
		echo "Securing MySQL Installation..."
		sudo mysql_secure_installation
		echo "MySQL secured."
	fi
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

install_mysql

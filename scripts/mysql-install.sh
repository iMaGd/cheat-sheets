#!/bin/bash

# Exit on error
set -e

# Prompt to choose between MySQL and MariaDB
read -p "Do you want to install MySQL or MariaDB? Type 'mysql' or 'mariadb': " db_choice

# Convertes the choice to lowercase
db_choice=${db_choice,,}

# Install MySQL
install_mysql() {
    echo "Starting MySQL installation..."
    sudo apt update
    sudo apt install -y mysql-server
    sudo systemctl start mysql.service
    sudo systemctl enable mysql.service
    echo "MySQL installation completed."
    echo "Securing MySQL Installation..."
    sudo mysql_secure_installation
    echo "MySQL secured."
}

# Install MariaDB
install_mariadb() {
    echo "Starting MariaDB installation..."
    sudo apt update
    sudo apt install -y mariadb-server
    sudo systemctl start mariadb.service
    sudo systemctl enable mariadb.service
    echo "MariaDB installation completed."
    echo "Securing MariaDB Installation..."
    sudo mysql_secure_installation
    echo "MariaDB secured."
}

# Installation choice
case $db_choice in
    mysql)
        install_mysql
        ;;
    mariadb)
        install_mariadb
        ;;
    *)
        echo "Invalid choice. Exiting installation."
        exit 1
        ;;
esac

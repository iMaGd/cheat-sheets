#!/bin/bash

set -e

# Prompt for database root user credentials
read -p "Enter MySQL/MariaDB root user: " root_user
read -s -p "Enter MySQL/MariaDB root password: " root_pass
echo ""

# Prompt for new database username and password
read -p "Enter new database username: " db_user
read -s -p "Enter new database user password: " db_pass
echo ""

# Prompt for database where the privileges should be set
read -p "Enter database name (leave blank for all databases): " db_name


# Connect to MySQL/MariaDB server and create new user
mysql --user="$root_user" --password="$root_pass" --execute="
CREATE USER '$db_user'@'localhost' IDENTIFIED BY '$db_pass';"

# Set up privileges
if [[ -z "${db_name// }" ]]; then
    echo "Granting all privileges on all databases to $db_user..."
    mysql --user="$root_user" --password="$root_pass" --execute="
    GRANT ALL PRIVILEGES ON *.* TO '$db_user'@'localhost' WITH GRANT OPTION;"
else
    echo "Granting all privileges on database '$db_name' to $db_user..."
    mysql --user="$root_user" --password="$root_pass" --execute="
    GRANT ALL PRIVILEGES ON \`${db_name// /_}\`.* TO '$db_user'@'localhost';"
fi

mysql --user="$root_user" --password="$root_pass" --execute="FLUSH PRIVILEGES;"

echo "Privileges have been assigned."
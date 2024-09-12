#!/bin/bash

set -e

# Prompt for database root user credentials
read -p "Enter MySQL/MariaDB root user [Default: root]: " root_user
root_user=${root_user:-root}
read -s -p "Enter MySQL/MariaDB root password: " root_pass
echo ""

# Verify credentials
if mysql -u"$root_user" -p"$root_pass" -e "quit" 2>/dev/null; then
    echo "Credentials are correct."
else
    echo "Wrong credentials."
    exit 1
fi

# Prompt for new database username and password
read -p "Enter new database user: " db_user
read -s -p "Enter new database user password (leave blank to auto generate a strong password): " db_pass
echo ""

# Generate a strong password if it is empty
if [[ -z "${db_pass// }" ]]; then
    db_pass=$(openssl rand -base64 12)
fi

# Prompt for database where the privileges should be set
read -p "Enter database name (leave blank for all databases): " db_name

# Prompt for the host or IP address from which the user should be allowed to connect
read -p "Enter the host or IP address for remote access (or %) (leave blank for localhost): " db_host
db_host=${db_host:-localhost}

# Create database if it does not exist
mysql --user="$root_user" --password="$root_pass" --execute="CREATE DATABASE IF NOT EXISTS $db_name;"

# Connect to MySQL/MariaDB server and create new user
mysql --user="$root_user" --password="$root_pass" --execute="
CREATE USER '$db_user'@'$db_host' IDENTIFIED BY '$db_pass';"

# Set up privileges
if [[ -z "${db_name// }" ]]; then
    echo "Granting all privileges on all databases to $db_user..."
    mysql --user="$root_user" --password="$root_pass" --execute="
    GRANT ALL PRIVILEGES ON *.* TO '$db_user'@'$db_host' WITH GRANT OPTION;"
else
    echo "Granting all privileges on database '$db_name' to $db_user..."
    mysql --user="$root_user" --password="$root_pass" --execute="
    GRANT ALL PRIVILEGES ON \`${db_name// /_}\`.* TO '$db_user'@'$db_host';"
fi

mysql --user="$root_user" --password="$root_pass" --execute="FLUSH PRIVILEGES;"

# Output the username and password
echo "New database user '$db_user' created with the password '$db_pass'"
echo "User is allowed to connect from '$db_host'"

echo "Privileges have been assigned."

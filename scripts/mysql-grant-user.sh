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

# Prompt for the database username and password
read -p "Enter the database user to grant: " db_user

# Prompt for database where the privileges should be set
read -p "Enter database name to grant to this user (leave blank for all databases): " db_name

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
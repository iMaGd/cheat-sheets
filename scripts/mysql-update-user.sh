#!/bin/bash

set -e

# Prompt for database root user credentials
read -p "Enter MySQL/MariaDB username [Default: root]: " username
username=${username:-root}
read -s -p "Enter MySQL/MariaDB user password: " user_pass
echo ""

# Verify credentials
if mysql -u"$username" -p"$user_pass" -e "quit" 2>/dev/null; then
    echo "Credentials are correct."
else
    echo "Wrong credentials."
    exit 1
fi

# Prompt for the new MySQL root password
read -sp "Enter the new password: " new_password
echo

# Change the MySQL user password
mysql -u ${username} -p"${user_pass}" -e "
ALTER USER '${username}'@'localhost' IDENTIFIED BY '${new_password}';
FLUSH PRIVILEGES;
"

echo "MySQL ${username} password changed successfully."
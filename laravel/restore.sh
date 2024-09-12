#!/bin/bash

# Define variables
APP_PATH="/home/username/www"
USER="username"
SERVER="10.10.10.10"
SHARED_FOLDER="${APP_PATH}/shared"
RELEASE_FOLDER="${APP_PATH}/releases"
CURRENT_FOLDER="${APP_PATH}/current"
TIMESTAMP="2024081025455" # Change this to release folder name


ssh -t ${USER}@${SERVER} "
    set -e

    # Passing Local variables
    SHARED_FOLDER=\"${SHARED_FOLDER}\"
    ENV_PATH=\"${APP_PATH}/.env\"
    RELEASE_FOLDER=\"${RELEASE_FOLDER}\"
    CURRENT_FOLDER=\"${CURRENT_FOLDER}\"
    TIMESTAMP=\"${TIMESTAMP}\"
    USER=\"${USER}\"

	ln -nfs \${RELEASE_FOLDER}/\${TIMESTAMP} \${CURRENT_FOLDER}

    cd \${CURRENT_FOLDER}
    php artisan config:cache

    # Restart PHP-FPM and Nginx to apply changes
    echo \"Restarting services...\"
    sudo service php8.3-fpm restart
    sudo service php8.3-fpm status
    sudo service nginx restart
    sudo service nginx status
"

echo "Services reloaded!"
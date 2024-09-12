#!/bin/bash

# Define variables
APP_PATH="/home/username/www"
USER="username"
SERVER="10.10.10.10"
SHARED_FOLDER="${APP_PATH}/shared"
RELEASE_FOLDER="${APP_PATH}/releases"
CURRENT_FOLDER="${APP_PATH}/current"
TIMESTAMP=$(date +"%Y%m%d%H%M%S")

composer install --no-interaction --prefer-dist --optimize-autoloader

# Clear caches
echo "Clearing caches"
php artisan config:cache
php artisan route:cache
php artisan view:cache

echo "Starting deployment of new release..."

# Create the release folder
ssh -t ${USER}@${SERVER} "
    set -e

    # Passing Local variables
    SHARED_FOLDER=\"${SHARED_FOLDER}\"
    RELEASE_FOLDER=\"${RELEASE_FOLDER}\"
    CURRENT_FOLDER=\"${CURRENT_FOLDER}\"
    TIMESTAMP=\"${TIMESTAMP}\"

    mkdir -p "\${RELEASE_FOLDER}/\${TIMESTAMP}"
    mkdir -p "\${SHARED_FOLDER}/app"
    mkdir -p "\${SHARED_FOLDER}/logs"
"

# Sync the latest files to a new release folder
echo "Syncing files to the server..."
rsync -avz --exclude '.env' --exclude '.git' --exclude 'node_modules' --exclude 'tests' --exclude 'storage/app/public' --exclude 'storage/app/uploads' --exclude 'vendor' . ${USER}@${SERVER}:${RELEASE_FOLDER}/${TIMESTAMP}

ssh -t ${USER}@${SERVER} "
    set -e

    # Passing Local variables
    SHARED_FOLDER=\"${SHARED_FOLDER}\"
    ENV_PATH=\"${APP_PATH}/.env\"
    RELEASE_FOLDER=\"${RELEASE_FOLDER}\"
    CURRENT_FOLDER=\"${CURRENT_FOLDER}\"
    TIMESTAMP=\"${TIMESTAMP}\"
    USER=\"${USER}\"

    # Install composer dependencies in the new release folder
    cd \${RELEASE_FOLDER}/\${TIMESTAMP}
    echo \"Installing Composer dependencies...\"
    composer install --optimize-autoloader --no-dev

    # Check if .env file exists, and if not, generate it
    if [ ! -f \${ENV_PATH} ]; then
        echo \".env file not found. Creating .env file...\"
        cp .env.example .env
        php artisan key:generate --ansi
        cp .env \${ENV_PATH}
    fi

    # Symlink the .env file to the current release
    ln -nfs \${ENV_PATH} ${RELEASE_FOLDER}/${TIMESTAMP}/.env

    # Set permissions for storage and cache directories
    echo \"Setting permissions...\"
    chown -R \${USER}:\${USER} storage bootstrap/cache
    chmod -R 775 storage bootstrap/cache

    # Create a symlink for shared directory
    echo \"Creating symlink for shared directory...\"
    rm -rf storage/app
    rm -rf storage/logs
    ln -nfs \${SHARED_FOLDER}/app storage/app
    ln -nfs \${SHARED_FOLDER}/logs storage/logs

    # Update symlink to point to the new release
    echo \"Updating symlink to point to the new release...\"
    # Remove previous symlink
    rm -f \${CURRENT_FOLDER}
    ln -nfs \${RELEASE_FOLDER}/\${TIMESTAMP} \${CURRENT_FOLDER}

    # Run database migrations
    echo \"Running migrations...\"
    php artisan migrate --force

    # Clear and cache config/routes/views
    echo \"Clearing and caching config/routes/views...\"
    php artisan config:cache
    php artisan route:cache
    php artisan view:cache
    echo \"All cleared...\"

    # Cleanup old releases (keep last 5)
    cd \${RELEASE_FOLDER}
    ls -t | tail -n +6 | xargs rm -rf

    # Restart PHP-FPM and Nginx to apply changes
    echo \"Restarting services...\"
    sudo service php8.3-fpm restart
    sudo service php8.3-fpm status
    sudo service nginx restart
    sudo service nginx status

    sudo supervisorctl restart horizon
"

echo "Deployment complete!"

#!/bin/bash

# Exit on any command failure.
set -e

# Download the Composer installer.
EXPECTED_SIGNATURE="$(curl -sS https://composer.github.io/installer.sig)"
php -r "copy('https://getcomposer.org/installer', '/tmp/composer-setup.php');"
ACTUAL_SIGNATURE="$(php -r "echo hash_file('sha384', '/tmp/composer-setup.php');")"

# Verify the installer signature.
if [ "$EXPECTED_SIGNATURE" != "$ACTUAL_SIGNATURE" ]
then
    >&2 echo 'ERROR: Invalid installer signature'
    sudo rm /tmp/composer-setup.php
    exit 1
fi

# Run the installer.
sudo php /tmp/composer-setup.php --quiet --install-dir=/usr/local/bin --filename=composer
RESULT=$?
sudo rm /tmp/composer-setup.php

# Check outcome of installation.
if [ $RESULT -eq 0 ]; then
    echo "Composer successfully installed!"
else
    echo "Composer installation failed."
    exit 1
fi

# Check Composer version.
composer --version
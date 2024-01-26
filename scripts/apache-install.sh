#!/bin/bash

# Exit on error
set -e

# Check if run as root or with sudo
if [[ $(id -u) -ne 0 ]]; then
    echo "This script must be run as root or with sudo privileges!" >&2
    exit 1
fi

# Update system packages
echo "Updating package lists..."
sudo apt update

# Install Apache2
echo "Installing Apache2..."
sudo apt install -y apache2 apache2-utils python3-certbot-apache

# Enable common mods
echo "Enabling mod_rewrite..."
sudo a2enmod rewrite headers ssl dir deflate expires


echo "Apache2 is installed"

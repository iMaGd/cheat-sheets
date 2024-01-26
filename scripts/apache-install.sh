#!/bin/bash

# Exit on error
set -e

# Install Apache2
echo "Installing Apache2..."
sudo apt install -y apache2 apache2-utils

# Enable common mods
echo "Enabling mod_rewrite..."
sudo a2enmod rewrite headers ssl dir deflate expires


echo "Apache2 is installed"

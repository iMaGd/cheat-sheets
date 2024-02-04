#!/bin/bash

# Exit on error
set -e

# Install Nginx
echo "Installing Nginx..."
sudo apt install -y nginx

# Install web server benchmark tool
sudo apt install -y apache2-utils

# Enable Nginx to run on system start
sudo systemctl enable nginx
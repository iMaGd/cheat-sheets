#!/bin/bash

# Exit on error
set -e

# Install Nginx
echo "Installing Nginx..."
sudo apt install -y nginx

# Enable Nginx to run on system start
sudo systemctl enable nginx
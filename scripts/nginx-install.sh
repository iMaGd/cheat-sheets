#!/bin/bash

# Exit on error
set -e

# Check if run as root or with sudo
if [[ $(id -u) -ne 0 ]]; then
    echo "This script must be run as root or with sudo privileges!" >&2
    exit 1
fi

# Install Nginx
echo "Installing Nginx..."
apt install -y nginx

# Enable Nginx to run on system start
systemctl enable nginx
#!/bin/bash

# Exit on error
set -e


# Prompt the user to confirm DNS record setup
read -p "Have you set up a DNS A Record to point your domain to this server's IP address? (y/n): " dns_setup_confirmed

# Convert input to lowercase and check
dns_setup_confirmed="${dns_setup_confirmed,,}"

if [ "$dns_setup_confirmed" != "y" ]; then
    echo "Please setup a DNS A Record before continuing. Terminated .."
    exit 1
fi

# Checking if a service is active
is_service_active() {
    sudo systemctl is-active --quiet "$1"
}

# Check for web server installation
if is_service_active apache2; then
    web_server="Apache"
    certbot_plugin="apache"
    echo "You are using 'apache2' as webserver."
elif is_service_active nginx; then
    web_server="Nginx"
    certbot_plugin="nginx"
    echo "You are using 'nginx' as webserver."
else
    echo "No supported web server (Apache or Nginx) found. Please install a web server and try again."
    exit 1
fi


# Prompt user for the domain and email address
read -p "Enter the domain name for the SSL certificate (e.g., example.com): " domain_name
read -p "Enter your email address for urgent notices and lost key recovery: " email_address


# Install Certbot and the appropriate plugin for the detected web server
echo "Installing Certbot with the $web_server plugin..."
sudo apt install -y certbot python3-certbot-"$certbot_plugin"

# Obtain and install SSL certificate
echo "Requesting SSL certificate for $domain_name..."
sudo certbot --"$certbot_plugin" --non-interactive --agree-tos -m "$email_address" -d "$domain_name" --redirect

echo "SSL certificate installation complete."
## System Administration and Linux Server Management Cheat Sheets

This repository contains a collection of cheat sheets useful for system administration and managing Linux servers, with a focus on tasks like configuring servers, managing users, and deploying applications.

### Get started

Clone the repository and permit for execution
```bash
git clone https://github.com/iMaGd/cheat-sheets.git && cd cheat-sheets
sudo chmod +x ./scripts/*.sh
```

### Get latest changes

To get latest changes from repo:
```bash
sudo chmod -x ./scripts/*.sh && git pull && sudo chmod +x ./scripts/*.sh
```

### List of available setup scripts

```bash
# Install Ubuntu server essentials
./scripts/ubuntu-init.sh

# Add admin/moderator/regular user to server
./scripts/adduser.sh

# You can switch to new super admin user
su superadmin

# Harden SSH
./scripts/ssh.sh

# Install and configure Fail2Ban
./scripts/fail2ban.sh

# Setup firewall
./scripts/iptables.sh

# Install Web-server
./scripts/apache-install.sh # Apache2
# OR
./scripts/nginx-install.sh  # Nginx

# Install PHP-FPM
./scripts/php-fpm.sh

# Install and secure Database
./scripts/mariadb-install.sh # MariaDB
# OR
./scripts/mysql-install.sh  # MySQL

# Add database user
./scripts/mysql-adduser.sh

# Install Composer
./scripts/composer-install.sh

# Add a virtual site
./scripts/apache-add-site.sh
# OR
./scripts/nginx-add-site.sh

# Install WP CLI
./scripts/wp-cli.sh

# Adds a WP site
./scripts/wp-add.sh

# Issue a SSL certificate
./scripts/ssl.sh

# Install PhpMyAdmin
./scripts/phpmyadmin.sh

```


### Contents

- [Install MySQL on Ubuntu 22.04](#install-mysql-on-ubuntu-2204)
- [Docker Commands](#docker-commands)
- [Install Docker and Docker Compose](#install-docker-and-docker-compose)
- [LAMP Boilerplate](#lamp-boilerplate)
- [LEMP Boilerplate](#lemp-boilerplate)
- [User Management and SSH User](#user-management-and-ssh-user)
- [SSH Key Authentication and Server Setup](#ssh-key-authentication-and-server-setup)
- [Enabling OpCache in PHP](#enabling-opcache-in-php)
- [PHP and PHP-FPM Configuration](#php-and-php-fpm-configuration)
- [SSH, Fail2ban, and Firewall Configuration](#ssh-fail2ban-and-firewall-configuration)
- [Enable SSL with Certbot](#enable-ssl-with-certbot)
- [Understanding and Managing the `www-data` User](#understanding-and-managing-the-www-data-user)
- [Apache Virtual Hosts Setup](#apache-virtual-hosts-setup)
- [Configuring Nginx](#configuring-nginx)
- [Install WP CLI for WordPress Management](#install-wp-cli-for-wordpress-management)
- [WordPress Cookies and Sessions](#wordpress-cookies-and-sessions)
- [WordPress Multisite and Single Rewrites](#wordpress-multisite-and-single-rewrites)
- [WordPress Media Management Commands](#wordpress-media-management-commands)
- [Directory and File Size Management Commands](#directory-and-file-size-management-commands)
- [Enable Custom CSS on WordPress Multisite](#enable-custom-css-on-wordpress-multisite)

### Install MySQL on Ubuntu 22.04
Cheat sheet for installing and securing MySQL on Ubuntu 22.04, including service management and user creation.

### Docker Commands
A collection of essential Docker commands for managing images and containers, as well as volume and network operations.

### Install Docker and Docker Compose
Steps to install Docker and Docker Compose on a Linux server.

### LAMP Boilerplate
A guide to setting up a Linux server with Apache, MySQL, and PHP (LAMP stack), including essential configurations.

### LEMP Boilerplate
Instructions for installing Nginx, PHP-FPM, and other necessary packages for a LEMP stack setup.

### User Management and SSH User
Commands for creating users, managing group membership, and configuring an SSH user for secure tunneling.

### SSH Key Authentication and Server Setup
How to set up SSH key-based authentication and configure server settings for added security.

### Enabling OpCache in PHP
Configuration options to enable and manage the OpCache extension for PHP.

### PHP and PHP-FPM Configuration
Guidance on tweaking PHP and PHP-FPM settings based on resource availability and application requirements.

### SSH, Fail2ban, and Firewall Configuration
Securing SSH access, installing Fail2ban, and configuring a firewall with iptables.

### Enable SSL with Certbot
Commands to enable SSL using Certbot for domains managed by Apache.

### Understanding and Managing the `www-data` User
Best practices for managing file ownership and permissions when running web servers and PHP-FPM.

### Apache Virtual Hosts Setup
Examples of Apache virtual host configurations for different scenarios including React applications and proxy to other servers or ports.

### Configuring Nginx
Basic Nginx server block configuration and virtual host setup for WordPress Multisite.

### Install WP CLI for WordPress Management
Instructions for installing WP CLI to streamline management of WordPress installations.

### WordPress Cookies and Sessions
Understanding different types of cookies and their usage in WordPress.

### WordPress Multisite and Single Rewrites
Code templates for Apache mod_rewrite compatible with WordPress multisite (using directories or root) and single sites.

### WordPress Media Management Commands
Command line operations to manage WordPress media, including removal and compression of images.

### Directory and File Size Management Commands
Quick commands to review and manage the sizes of directories and files.

### Enable Custom CSS on WordPress Multisite
A code snippet to allow custom CSS for users with appropriate capabilities on a WordPress Multisite network.

---
For more detailed information, please refer to the respective cheat sheets within this repository.

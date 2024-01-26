#!/bin/bash

# Exit on error
set -e

# Updates the package list and installs required packages.
sudo apt update && sudo apt upgrade -y

# enables easier management of third-party software sources and is important when you want to install software from sources that are not available in the default Ubuntu repositories
sudo apt install -y software-properties-common

sudo apt install -y \
  unzip zip nano openssh-server \
  curl wget axel \
  htop pv tree git nano pwgen \
  openssl certbot

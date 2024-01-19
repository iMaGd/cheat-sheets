#!/bin/bash

sudo apt update && sudo apt upgrade -y

sudo apt install -y \
  unzip zip nano openssh-server \
  curl wget axel \
  htop pv tree git nano pwgen \
  openssl certbot

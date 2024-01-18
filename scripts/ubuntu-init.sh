#!/bin/bash

apt update && apt upgrade -y

apt install -y \
  unzip zip nano openssh-server \
  curl wget axel \
  htop pv tree git nano pwgen \
  openssl certbot

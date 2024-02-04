#!/bin/bash

# Install Redis
sudo apt install redis-server -y

# Configure Redis
sudo cp /etc/redis/redis.conf /etc/redis/redis.conf.bk
sudo sed -i 's/supervised no/supervised systemd/' /etc/redis/redis.conf
sudo sed -i 's/bind 127.0.0.1 ::1/bind 127.0.0.1/' /etc/redis/redis.conf

# Start and enable Redis service
sudo systemctl start redis
sudo systemctl enable redis

# Verify Redis installation
sudo redis-cli ping

echo "Redis installation completed."

echo "You need to restart php-fpm service as well."
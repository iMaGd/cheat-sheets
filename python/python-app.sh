#!/bin/bash

# Variables
APP_DIR="/var/www/pyapp"
VENV_DIR="$APP_DIR/venv"
GUNICORN_SOCK="$APP_DIR/pyapp.sock"

# Update and upgrade the system
echo "Updating and upgrading system..."
sudo apt update
sudo apt upgrade -y

echo "Installing basic utilities..."
apt install -y curl wget git build-essential

# Install necessary packages
echo "Installing Python and pip..."
sudo apt install python3 python3-pip python3-venv nginx -y

# Create the application directory
echo "Creating application directory"
sudo mkdir -p $APP_DIR

# Create a virtual env
echo "Creating Python virtual env ..."
python3 -m venv $VENV_DIR

# Activate the virtual env and install Flask and Gunicorn
echo "Installing Flask and Gunicorn..."
source $VENV_DIR/bin/activate
pip install flask gunicorn
deactivate

# Create the Flask app
echo "Creating app.py file..."
cat <<EOF > $APP_DIR/app.py
from flask import Flask
app = Flask(__name__)

@app.route('/hello')
def hello_world():
    return 'Hello, World!'

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
EOF

# Create the WSGI entry point
cat <<EOF > $APP_DIR/wsgi.py
from app import app

if __name__ == '__main__':
    app.run()
EOF

# Create the Nginx configuration file
cat <<EOF > /etc/nginx/sites-available/pyapp
server {
    listen 80;
    server_name your_domain_or_IP;

    location / {
        proxy_pass http://unix:$GUNICORN_SOCK;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}
EOF

# Enable the new Nginx configuration
sudo ln -s /etc/nginx/sites-available/pyapp /etc/nginx/sites-enabled

# Disable the default Nginx configuration
sudo unlink /etc/nginx/sites-enabled/default

# Test the Nginx configuration
sudo nginx -t

# Reload Nginx to apply the changes
sudo systemctl reload nginx

# Create the systemd service file for Gunicorn
cat <<EOF > /etc/systemd/system/pyapp.service
[Unit]
Description=Gunicorn instance to serve pyapp
After=network.target

[Service]
User=root
Group=www-data
WorkingDirectory=$APP_DIR
Environment="PATH=$VENV_DIR/bin"
ExecStart=$VENV_DIR/bin/gunicorn --workers 4 --bind unix:$GUNICORN_SOCK -m 007 wsgi:app

[Install]
WantedBy=multi-user.target
EOF

# Start and enable the Gunicorn service
sudo systemctl start pyapp
sudo systemctl enable pyapp

echo "Setup complete."

# =====================

# If you changed the app, you need to reload the service
sudo systemctl restart pyapp

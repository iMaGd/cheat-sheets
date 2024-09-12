#!/bin/bash

#Install Supervisor
sudo apt install supervisor -y

sudo nano /etc/supervisor/conf.d/horizon.conf


# Create PHP-FPM pool configuration for the user
sudo bash -c "cat > /etc/supervisor/conf.d/horizon.conf << EOF
[program:horizon]
process_name=%(program_name)s
command=php /home/no-bg/www/current/artisan horizon
autostart=true
autorestart=true
user=no-bg
redirect_stderr=true
stdout_logfile=/home/no-bg/www/current/storage/logs/horizon.log
stopwaitsecs=600
EOF"


# 'stopwaitsecs' is is greater than the number of seconds consumed by your longest running job

sudo supervisorctl reread
sudo supervisorctl update
sudo supervisorctl start horizon

# To check supervisor log
sudo tail -f /var/log/supervisor/supervisord.log

# test horizon
sudo supervisorctl restart horizon


sudo crontab -e

* * * * * cd /home/no-bg/www/current && php artisan schedule:run >> /dev/null 2>&1


sudo tail -f /var/log/nginx/laravel_error.log


sudo supervisorctl status

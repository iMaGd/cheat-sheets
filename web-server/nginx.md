
## Configuring Nginx

```bash
nano /etc/nginx/sites-available/example.conf
```

### Virtual Site on I
```
server {
    listen 80 default_server;
    listen [::]:80 default_server;

    server_name _;

    root /var/www/example/public;

    index index.html index.htm index.php;

    client_max_body_size 32M;

    location / {
        try_files $uri $uri/ /index.php?$query_string;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/run/php/php7.4-fpm.sock;
    }
}
```

### Link to Enabled Sites
```bash
sudo ln -s /etc/nginx/sites-available/example /etc/nginx/sites-enabled/
```

### Config for WordPress Multisite Using Directories

```nginx
server {
    listen 80;
    server_name ww.example.com;

    root /var/www/wpmu;
    index index.php;

    client_max_body_size 32M;

    location / {
        try_files $uri $uri/ /index.php?$args;
    }

    location ~ ^/[_0-9a-zA-Z-]+/files/(.*)$ {
        try_files /wp-content/blogs.dir/$blogid/$uri /wp-includes/ms-files.php?file=$1 ;
        access_log off; log_not_found off; expires max;
    }

    # Avoid PHP parsing for known requests
    location ~* \.(js|css|png|jpg|jpeg|gif|ico)$ {
        expires max;
        log_not_found off;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/run/php/php8.1-fpm-wpmu.sock;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        include fastcgi_params;
    }

    # Directives to send expires headers and turn off 404 error logging.
    location ~* ^/[_0-9a-zA-Z-]+/(wp-(content|admin|includes).*) {
        try_files $uri $uri/ /index.php?$args ;
    }

    location ~* ^/[_0-9a-zA-Z-]+/(.*\.php)$ {
        try_files $uri /index.php?$args ;
    }

    location ~ /xmlrpc.php$ {
        deny all;
    }
}
```

## Configuring Nginx

Simple example:

```bash
nano /etc/nginx/sites-available/example.conf
```

### Default Virtual Site
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

----

### SSL om Ports

- Port 443 is the well-known default for HTTPS.
- You can enable TLS on any TCP port.
- The port must be configured with a TLS certificate and knows how to handle the TLS handshake.

**Configuration for enabling TLS on port 8443**

```
# /etc/nginx/sites-available/domain.com

# 1. HTTP on :80 (no TLS) — redirect to HTTPS
server {
    listen 80;
    listen [::]:80;
    server_name domain.com www.domain.com;

    return 301 https://$host$request_uri;
}

# 2. HTTPS on :443
server {
    listen 443 ssl http2;
    listen [::]:443 ssl http2;
    server_name domain.com www.domain.com;

    ssl_certificate     /etc/ssl/certs/domain.com.fullchain.pem;
    ssl_certificate_key /etc/ssl/private/domain.com.key;

    # (optional hardening)
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers HIGH:!aNULL:!MD5;

    root /var/www/domain.com/public;
    index index.php index.html;
}

# 3) HTTPS on :8443 (same cert; different port)
server {
    listen 8026 ssl http2;
    listen [::]:8026 ssl http2;
    server_name domain.com;

    ssl_certificate     /etc/ssl/certs/domain.com.fullchain.pem;
    ssl_certificate_key /etc/ssl/private/domain.com.key;

    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers HIGH:!aNULL:!MD5;

    # You can serve a different app/root here if you want
    root /var/www/domain.com-8026/public;
    index index.php index.html;
}
```

**Reload the webserver**
```
sudo nginx -t && sudo service nginx reload
```

----

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
-------

## Pass Protect Directory

See [htpasswd guide](./htpasswd.md) for password protecting directories

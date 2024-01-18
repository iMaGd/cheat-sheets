
## Simple Virtual Host

```bash
<VirtualHost *:80>
  ServerName example.com
  ServerAlias www.example.com

  DocumentRoot /var/www/example

  <Directory "/var/www/example">
    RewriteEngine On
    # Don't rewrite files or directories
    RewriteCond %{REQUEST_FILENAME} -f [OR]
    RewriteCond %{REQUEST_FILENAME} -d
    RewriteRule ^ - [L]
    # Rewrite everything else to index.html to allow html5 state links
    RewriteRule ^ index.html [L]
  </Directory>
</VirtualHost>
```

### Complete Virtual Host
```apache
<VirtualHost *:80>
	ServerName example.com
	ServerAlias www.example.com

	DocumentRoot /var/www/html

	<Directory "/var/www/html/">
        # Don't show directory index
        Options -Indexes +FollowSymLinks +MultiViews
        # Allow .htaccess files
		AllowOverride All
        # Allow web access to this directory
		Require all granted
	</Directory>
	<FilesMatch \.php$>
		# 2.4.10+ can proxy to unix socket
		SetHandler "proxy:unix:/var/run/php/php8.1-fpm.sock|fcgi://localhost"
	</FilesMatch>

	ErrorLog ${APACHE_LOG_DIR}/example.error.log
	CustomLog ${APACHE_LOG_DIR}/example.access.log combined
</VirtualHost>
```

```apache
<IfModule mod_ssl.c>
SSLStaplingCache shmcb:/var/run/apache2/stapling_cache(128000)
<VirtualHost *:443>
        ServerName example.com
        ServerAlias www.example.com

        DocumentRoot /var/www/html

        <Directory /var/www/html/>
            Options Indexes FollowSymLinks MultiViews
            AllowOverride All
            Require all granted
        </Directory>
         <FilesMatch \.php$>
            # 2.4.10+ can proxy to unix socket
            SetHandler "proxy:unix:/var/run/php/php8.1-fpm.sock|fcgi://localhost"
        </FilesMatch>

        ErrorLog ${APACHE_LOG_DIR}/example.error.log
        CustomLog ${APACHE_LOG_DIR}/example.access.log combined

SSLCertificateFile /etc/letsencrypt/live/example.com/fullchain.pem
SSLCertificateKeyFile /etc/letsencrypt/live/example.com/privkey.pem
Include /etc/letsencrypt/options-ssl-apache.conf
Header always set Strict-Transport-Security "max-age=31536000"
SSLUseStapling on
</VirtualHost>
</IfModule>
```



### To proxy a subdomain to another server or port
```bash
<VirtualHost sub.example.com:80>
    ServerName sub.example.com
    ServerAlias sub.example.com
    CustomLog /var/log/apache2/access.log combined

    RequestHeader set X-Forwarded-Proto https
    ProxyPreserveHost On
    ProxyPass / http://localhost:8080/
    ProxyPassReverse / http://localhost:8080/
</VirtualHost>
```

------

## Setup for React Rout

Add following to virtual host conf file
```
<Directory "/var/www/html">
    RewriteEngine on
    # Don't rewrite files or directories
    RewriteCond %{REQUEST_FILENAME} -f [OR]
    RewriteCond %{REQUEST_FILENAME} -d
    RewriteRule ^ - [L]
    # Rewrite everything else to index.html to allow html5 state links
    RewriteRule ^ index.html [L]
</Directory>
```

CORS Setup

```bash
nano /etc/apache2/conf-available/security.conf

# Add following
Header always set Access-Control-Allow-Origin "*"
Header always set Access-Control-Allow-Methods "POST, GET, OPTIONS, PUT"
Header always set Access-Control-Allow-Headers "append,delete,entries,foreach,get,has,keys,set,values,Authorization"

# or abstracted version
Header always set Access-Control-Allow-Origin "*"
Header always set Access-Control-Allow-Methods "POST, GET, OPTIONS"
Header always set Access-Control-Allow-Headers "Authorization"

# and add to htaccess
RewriteCond %{REQUEST_METHOD} OPTIONS
RewriteRule ^(.*)$ $1 [R=200,L]
```

-------

## Pass Protect Directory
Add new username and password

```bash
sudo htpasswd -c /etc/apache2/.htpasswd majid
```

Create new .htaccess file in the directory and add the following
```bash
AuthType Basic
AuthName "Password Required"
Require valid-user
AuthUserFile /etc/apache2/.htpasswd
```

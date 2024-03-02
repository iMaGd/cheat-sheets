## Install phpMyAdmin on a LEMP stack


```sh
sudo apt-get install phpmyadmin
```

During the installation, you may be prompted to choose the web server that should be automatically configured. Since you're running Nginx, none will be selected, so just press TAB and then ENTER to continue without selecting a web server.

You'll also be prompted whether to use `dbconfig-common` to set up the database. You can choose yes and provide your MySQL/MariaDB root password.

**Configure Nginx to Serve phpMyAdmin**

To access phpMyAdmin from a `/pma` directory on your domain, you will need to configure Nginx to serve phpMyAdmin.

Ensure that phpMyAdmin is installed under `/usr/share/phpmyadmin`.

You can create a symbolic link from the main phpMyAdmin directory to your website's directory.

```sh
sudo ln -s /usr/share/phpmyadmin /var/www/html/phpmyadmin
```

If you have a configuration file for your domain, edit that one:

```sh
sudo nano /etc/nginx/sites-available/yourdomain.com
```

Add the following location block within your `server` block:

```nginx
location /pma {
	alias /var/www/html/phpmyadmin/;
	index index.php index.html index.htm;

	location ~ ^/pma/(.+\.php)$ {
		try_files $uri =404;
		fastcgi_pass unix:/run/php/php8.1-fpm.sock;
		fastcgi_index index.php;
		fastcgi_param SCRIPT_FILENAME $request_filename;
		include /etc/nginx/fastcgi_params;
	}

	location ~* ^/pma/(.+\.(jpeg|jpg|png|css|gif|ico|js|html|xml|ttf|woff|svg|eot))$ {
		alias /var/www/html/phpmyadmin/;
	}
}

location /pma {
	alias /usr/share/phpmyadmin/;
	try_files $uri $uri/ /pma/index.php$is_args$args;

	location ~ ^/pma/(.+\.php)$ {
		try_files \$uri =404;
		fastcgi_pass unix:/var/run/php/php8.1-fpm.sock;
		fastcgi_index index.php;
		fastcgi_param SCRIPT_FILENAME $request_filename;
		include fastcgi_params;
	}

	location ~* ^/pma/(.+\.(jpeg|jpg|png|css|gif|ico|js|html|xml|txt))$ {
		alias /usr/share/phpmyadmin/$1;
	}
}
```

Test the Nginx configuration for syntax errors

```sh
sudo nginx -t
```

Reload Nginx to apply the changes:

```sh
sudo service nginx restart
```

Access and test PhpMyAdmin
```
http://domain_or_IP/pma
```

**Secure Your phpMyAdmin**

It's highly recommended to secure your phpMyAdmin instance:

- Use HTTPS by obtaining an SSL certificate (Using Certbot `sudo certbot --nginx`).
- [Consider setting up HTTP authentication](./../security/htpasswd.md) for an added security layer on the `/pma` location.
- Limit IP addresses that can access the `/pma` directory using the `allow` and `deny` directives.

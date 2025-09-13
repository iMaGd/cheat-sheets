To add an additional layer of security by implementing HTTP basic authentication for a directory, you'll need to create a password file using `htpasswd` and update your web server configuration to use that file for authentication.


## Ngnix Configuration

1. **Install Apache2 Utilities**

	The `htpasswd` utility is included in the `apache2-utils` package. Let's install it.

	```sh
	sudo apt install apache2-utils
	```

2. **Create/update the `.htpasswd` file**



	```sh
	# Install htpasswd utility (Debian/Ubuntu)
	sudo apt-get install -y apache2-utils

	# Create the secure directory (outside public folder)
	mkdir -p /home/my-user/secure
	chmod 700 /home/my-user/secure

	# Create or update an entry (will prompt for password)
	htpasswd -c /home/my-user/secure/.htpasswd my-user

	# Add more users (no -c)
	htpasswd /home/my-user/secure/.htpasswd anotheruser
	```


3. **Configure Nginx to Use HTTP Authentication**

	Open the Nginx configuration file for your website where the `/pma` location block is defined:

	```sh
	sudo nano /etc/nginx/sites-available/yourdomain.com
	```

	Within the server block, add the `auth_basic` and `auth_basic_user_file` directives like so:

	```nginx
	# Never serve dotfiles (.env, .htpasswd, .git, etc.)
    location ~ /\.(?!well-known) {
        deny all;
        access_log off;
        log_not_found off;
    }

	location / {
		auth_basic "Administrator Login";
		auth_basic_user_file /home/my-user/secure/.htpasswd;

		# ... existing configuration ...
		# try_files $uri $uri/ /index.php?$query_string;
	}
	```

4. **Verify and Restart Nginx Configuration**

	Test the Nginx configuration to ensure there are no syntax errors:

	```sh
	sudo nginx -t
	```

	```sh
	sudo service nginx restart
	```


## Apache2 Configuration

1. **Install Apache2 Utilities**

	The `htpasswd` utility is included in the `apache2-utils` package. Let's install it.

	```sh
	sudo apt install apache2-utils
	```

2. **Create an HTTP Authentication User File**

	The following command will create a new file and stores a username (`username`). Replace `username` with the username you want to use for phpMyAdmin login.

	```sh
	sudo htpasswd /etc/phpmyadmin/.htpasswd username
	```

3. **Configure Apache2 to Use HTTP Authentication**

	Open the Apache2 configuration file for your website where the `/pma` location block is defined:

	```sh
	sudo nano /etc/apache2/sites-available/yourdomain.com
	```

	Add these lines inside the `<Directory>` directive:

	```apache
	AuthType Basic
	AuthName "phpMyAdmin Secure Access"
	AuthUserFile /var/www/secure/.htpasswd
	Require valid-user
	```


	Or, add it to the virtual host file:

	```
	<VirtualHost *:443>
		ServerName secure.domain.com

		DocumentRoot /var/www/secure

		SSLEngine on
		SSLCertificateFile      /etc/ssl/certs/domain.com.fullchain.pem
		SSLCertificateKeyFile   /etc/ssl/private/domain.com.key
		Protocols h2 http/1.1

		<Directory "/var/www/secure">
			Options Indexes FollowSymLinks
			AllowOverride None
			Require all granted

			# Auth settings
			AuthType Basic
			AuthName "Restricted Area"
			AuthUserFile /var/www/secure/.htpasswd
			Require valid-user
		</Directory>

		# Block direct access to the .htpasswd and .htaccess files
		<FilesMatch "^\.ht">
			Require all denied
		</FilesMatch>
	</VirtualHost>
	```


4. **Reload Apache2 Configuration**

	```bash
	sudo apache2ctl configtest
	sudo service apache2 reload
	```

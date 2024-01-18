## Install WP CLI

```bash
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
php wp-cli.phar --info
sudo mv wp-cli.phar /usr/local/bin/wp
wp --info
```

### Install Fresh WordPress

```bash
wp core download
wp core config --dbname=wp_dev --dbuser=root --dbpass=password --dbhost=localhost --dbprefix=wp_ --extra-php <<PHP
define( 'WP_DEBUG', true );
define( 'WP_DEBUG_LOG', true );
PHP

wp db create
# multisite
wp core multisite-install --url=wp.test --base=/ --title="Development" --admin_user="admin" --admin_password="admin" --admin_email="admin@domain.com" --skip-email
# single site
wp core install --url=http://wp.test --title=Development --admin_user=username --admin_password=admin --admin_email=admin@domain.com

# after enabling ssl
wp search-replace http https
```

### Create Admin User
```bash
wp user create admin admin@example.com --role=admin --user_pass=secure_password
```

### List of Current Plugins
```bash
wp plugin list
```


### Installing Multiple Plugins
```bash
wp plugin install depicter elementor --activate
```

### Search and Replace Across Network
```bash
wp search-replace --network 'http://old-domain.com' 'http://new-domain.com' --url=old-domain.com --all-tables
wp cache flush
```
### Search and Replace in Some Tables
```bash
wp search-replace old-domain.com new-domain.com wp_site wp_blogs
```

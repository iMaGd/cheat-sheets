### Simple domain swap on the same server

```bash
wp search-replace 'domain.net' 'domain.com' --all-tables-with-prefix --network
wp cache flush
```

- Change domain.net in wp-config.php file.
- Run following command to update the certificate (assuming you are using ngnix)

```bash
sudo certbot --nginx -d domain.com
sudo certbot install --cert-name domain.com
```

### Migration to new server

```bash
#!/bin/bash

echo "1. Download database file from remote server? y/n "
read download

if [ "$download" = "y" ]
then
    rm -f /home/username/migration/demos.sql
    wget -P /home/username/migration/ http://<host_ip>/demos/exportDemos/demos.sql
fi

echo "2. Importing database "
pv /home/username/migration/demos.sql | mysql -u databaseUserName -p -h localhost databaseName

echo "3. Changing wordpress config"
wp config set DB_NAME 'databaseName' --path=/home/username/public_html/
wp config set DB_USER 'databaseUserName' --path=/home/username/public_html/
wp config set DOMAIN_CURRENT_SITE 'newDomain.com' --path=/home/username/public_html/

echo "4. Search and replace domain ..";
wp search-replace --network --all-tables 'http://oldDomain.com/subdirectory' 'https://newDomain.com' \
--verbose --report-changed-only --path=/home/username/public_html/

wp search-replace 'oldDomain.com' 'newDomain.com' wp_site wp_blogs \
--verbose --path=/home/username/public_html/

echo "5. Search and replace domain in Elementor..";
wp search-replace --network http:\\\/\\\/oldDomain.com\\\/subdirectory https:\\\/\\\/newDomain.com wp*_postmeta \
--verbose --report-changed-only --path=/home/username/public_html/

wp search-replace --network '/subdirectory/' '/' --all-tables --verbose --path=/home/username/public_html/

echo "6. Flushing cache .."

wp rewrite flush --path=/home/username/public_html/
wp cache flush --path=/home/username/public_html/

echo "7. Flushing assets .. "
wp site list --field=url --path=/home/username/public_html/ \
| xargs -n1 -I % wp elementor flush_css --newwork --url=% --path=/home/username/public_html/
wp site list --field=url --path=/home/username/public_html/ \
| xargs -n1 -I % wp autoptimize clear --url=% --path=/home/username/public_html/

echo "8. Migration completed!"
```

#### Sample 2

```bash
echo "Search and replace domain ..";
wp search-replace --network --all-tables-with-prefix 'https://demo.example.com' 'https://main.example.com' \
--verbose --report-changed-only --path=/var/www/html --allow-root


wp search-replace 'demo.example.com' 'main.example.com' wp_site wp_blogs \
--verbose --path=/var/www/html --allow-root

echo "5. Search and replace domain in Elementor..";
wp search-replace --network https:\\\/\\\/demo.example.com https:\\\/\\\/main.example.com wp*_postmeta \
--verbose --report-changed-only --path=/var/www/html --allow-root

echo "6. Flushing cache .."

wp rewrite flush --path=/var/www/html --allow-root
wp cache flush --path=/var/www/html --allow-root

echo "7. Flushing assets .. "
wp site list --field=url --path=/var/www/html --allow-root \
| xargs -n1 -I % wp elementor flush_css --network --url=% --path=/var/www/html --allow-root

wp site list --field=url --path=/var/www/html --allow-root \
| xargs -n1 -I % wp autoptimize clear --url=% --path=/var/www/html --allow-root
```

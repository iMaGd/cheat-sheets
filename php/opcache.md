
## Enabling OpCache

```bash
sudo nano /etc/php/8.1/fpm/php.ini
```

```ini
opcache.memory_consumption = 192      ; The OPcache shared memory storage size.
opcache.max_accelerated_files = 10000 ; The maximum number of keys (scripts) in the OPcache hash table.
opcache.validate_timestamps = 1       ; Determines if the timestamps are checked for changes. (set 0 for production)
```

```bash
# use reload to prevent terminating running processes
sudo service php8.1-fpm reload

# Or use restart
sudo service php8.1-fpm restart
```

### Monitor OpCache Status
```php
opcache_get_status();
```

-------

## Grant Access to an Isolated User For Flushing Cache
Run following command
```bash
sudo visudo
```
And add this line at the end of file.(username is 'user1')
```yaml
user1 ALL=NOPASSWD: /usr/sbin/service php8.1-fpm reload
```

Switch to the user and test for new privilege
```bash
sudo su user1
sudo service php8.1-fpm reload
```


## Configuration

### PHP Config
```bash
sudo nano /etc/php/8.1/fpm/php.ini
```
```ini
memory_limit = 512M                ; Maximum amount of memory a script may consume.
post_max_size = 32M                ; Maximum size of POST data (Should always be higher than upload_max_filesize)
upload_max_filesize = 32M          ; Maximum allowed size for uploaded files.
max_execution_time = 60            ; Maximum execution time of each script, in seconds.
max_input_time = 120               ; Maximum amount of time each script may spend parsing request data.
max_input_vars = 2000              ; Maximum number of input variables per request.
date.timezone = "UTC"              ; The default timezone for date functions. Adjust to your timezone.
session.gc_maxlifetime = 1440      ; Session garbage collection maximum lifetime.
opcache.enable = 1                 ; Enables the OPcache for improved performance.
opcache.memory_consumption = 192   ; The OPcache shared memory storage size.
opcache.max_accelerated_files = 10000 ; The maximum number of keys (scripts) in the OPcache hash table.
opcache.validate_timestamps = 1    ; Determines if the timestamps are checked for changes.
realpath_cache_size = 4096k        ; Determines the size of the realpath cache to be used by PHP.
realpath_cache_ttl = 600           ; How long (in seconds) to cache realpath information.
```

### FPM Config (www-data user)

```bash
sudo nano /etc/php/8.1/fpm/pool.d/www.conf
```

```ini
pm = dynamic
pm.max_children = 2000
pm.start_servers = 30
pm.min_spare_servers = 20
pm.max_spare_servers = 30

---------

# 16 GB ram
pm = dynamic
pm.max_children = 160
pm.start_servers = 40
pm.min_spare_servers = 40
pm.max_spare_servers = 120

# 8 GB ram
pm = dynamic
pm.max_children = 200
pm.start_servers = 50
pm.min_spare_servers = 50
pm.max_spare_servers = 150

# 4 GB ram
pm = dynamic
pm.max_children = 86
pm.start_servers = 21
pm.min_spare_servers = 21
pm.max_spare_servers = 64

# 2 GB ram
pm = dynamic
pm.max_children = 35
pm.start_servers = 8
pm.min_spare_servers = 8
pm.max_spare_servers = 26

```

### FPM Config (new user)
Make new file in pool for
```bash
sudo nano /etc/php/8.1/fpm/pool.d/newsite.conf

sudo service php8.1-fpm restart
```

#### Calculation Guide
```
[Total Available RAM] - [Reserved RAM] - [10% buffer] = [Available RAM for PHP]

Results:
[Available RAM for PHP] / [Average Process Size] = [max_children]

pm.max_children = [max_children]
pm.start_servers = [25% of max_children]
pm.min_spare_servers = [25% of max_children]
pm.max_spare_servers = [75% of max_children]
``````
> https://spot13.com/pmcalculator/

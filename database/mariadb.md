## Install MariaDB on Ubuntu 22.04

```bash
sudo apt update
sudo apt upgrade
sudo apt install mariadb-server -y

## Secure MariaDB
sudo mysql_secure_installation
```
## Start/Stop Service

```bash
# start and enable mysql
sudo systemctl start mariadb.service
sudo systemctl enable mariadb.service

# Other commands
service mariadb start;
service mariadb stop;
service mariadb restart;
service mariadb status;
```

## Basic Configuration (my.cnf / my.ini)

   The main configuration file for MariaDB is typically found at `/etc/mysql/my.cnf` or `/etc/mysql/mariadb.cnf` or `/etc/mysql/mariadb.conf.d/50-server.cnf`. You may include custom configuration settings within this file or in separate files under `/etc/mysql/mariadb.conf.d/`.

   For basic optimizations, you can start by adjusting some of the following settings under the `[mysqld]` section:

   ```
   [mysqld]
   max_connections = 151
   thread_cache_size = 8
   query_cache_limit = 1M
   query_cache_size = 16M
   ```

   For a more advanced setup, you might consider tuning the InnoDB settings, such as:

   ```
   innodb_buffer_pool_size = 256M
   innodb_log_file_size = 64M
   innodb_log_buffer_size = 8M
   expire_logs_days = 60
   # Max binary log size
   max_binlog_size = 1000M
   # disables general query logging
   general_log = 0
   ```

   **Note:** The ideal settings for these options depend on the specifics of your hardware and the nature of your application. Use tools like [mysqltuner.pl](https://github.com/major/MySQLTuner-perl) or [tuning-primer.sh](http://tuning-primer.sh) to analyze your database performance and get recommendations.

## To Change Password of Root User

```sql
sudo mysql -u root -p

mysql> ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'password'

FLUSH PRIVILEGES
```

## Create Admin User

Create a new user `admin` for the host `localhost` with a password:

```sql
mysql> CREATE USER 'admin'@'localhost' IDENTIFIED BY 'some_secure_password';
```

Grant all permissions for all tables to the new admin user

```sql
mysql> GRANT ALL PRIVILEGES ON *.* TO 'admin'@'localhost';

mysql> FLUSH PRIVILEGES;
```

## Create New User (Isolated)

Create a new user `newuser` for the host `localhost` with a password:

```sql
mysql> CREATE USER 'newuser'@'localhost' IDENTIFIED BY 'some_secure_password';
```

Create a database for this user

```sql
mysql> CREATE database new_db;
```
Grant all permissions for this table to the new user

```sql
mysql> GRANT ALL PRIVILEGES ON new_db.* TO 'newuser'@'localhost';

mysql> FLUSH PRIVILEGES;
```

## Create New Remote User (Isolated)

Create a new user `remote` which can be connected from outside with a password:

```sql
mysql> CREATE USER 'remote'@'%' IDENTIFIED BY 'some_secure_password';
```

Create a database for this user

```sql
mysql> CREATE database new_db;
```
Grant all permissions for this table to the new user

```sql
mysql> GRANT ALL PRIVILEGES ON new_db.* TO 'remote'@'%';

mysql> FLUSH PRIVILEGES;
```

## Grant Remote Access

```bash
nano /etc/mysql/mysql.conf.d/mysqld.cnf
```
change the line containing `bind-address` to `bind-address = 0.0.0.0`
```bash
service mysql restart
```

## To Connect to A Remote Database

```bash
mysql -u root -p -h <host_ip>
```

## Backups
Set up a backup routine for your databases. MariaDB's `mysqldump` utility is commonly used for making backups, which can be scheduled with `cron` jobs.


## Monitoring and Logs
Keep an eye on MariaDB logs located in `/var/log/mysql/` for errors or issues.


## Regular Database Maintenance
Regularly check your database's health with commands like:
```sql
CHECK TABLE tablename;
ANALYZE TABLE tablename;
OPTIMIZE TABLE tablename;
```

## Troubleshooting

- Check status `service mysql status`
- Check log file at `/var/log/mysql/error.log`
- Check configuration issues `sudo mysqlcheck --all-databases`
- Check disk space available `df -h`



```


## Understanding the `www-data` User

The `www-data` user is special user in server operations. Both Nginx and Apache, as well as PHP-FPM, utilize this user. It typically accesses public files within the application directories and should not have write access for security reasons. However, PHP-FPM uses the `www-data` user to execute PHP code and may sometimes require the ability to write to certain directories.

For convenience, when setting up quickly, we often assign `www-data` as the owner of the application directories.

### A More Secure Approach

A better practice for enhanced security is to create a dedicated user for running PHP-FPM. Here's how you can do that:

1. **Create a New User**

   Start by adding a new user to your server using the following command:

   ```bash
   sudo adduser example
   ```

2. **Relocate Your Application**

   Move your application to a dedicated directory within the new user's home space, such as `/home/example/www`.

3. **Configure PHP-FPM for the New User**

   Create a new PHP-FPM configuration file in `/etc/php/8.1/fpm/pool.d/`:

   ```bash
   sudo nano /etc/php/8.1/fpm/pool.d/example.conf
   ```

   Modify the configurations in the file to match:

   ```ini
   [example]
   user = example
   group = example
   listen = /run/php/php8.1-fpm.sock
   listen.owner = example
   listen.group = example
   pm = dynamic
   pm.max_children = 5
   pm.start_servers = 2
   pm.min_spare_servers = 1
   pm.max_spare_servers = 3
   ```

4. **Restart PHP-FPM**

   Apply the changes by restarting the service:

   ```bash
   sudo service php8.1-fpm restart
   ```

5. **Update Ownership**

   Change the ownership of the application directory to the new `example` user:

   ```bash
   sudo chown -R example:example /home/example/www
   ```

   Now PHP-FPM operates under the `example` user, with proper read, write, and execute permissions.

6. **Grant NGINX Read Access**

   Since Nginx still runs under the `www-data` user and requires only read access, simply add `www-data` to the `example` group. This will enable `www-data` to read files owned by the `example` user:

   ```bash
   sudo usermod -aG example www-data
   ```

After completing these steps, the `/home/example/www` directory is secure, accessible only by the `example` user, and both PHP-FPM and Nginx have the necessary permissions to serve the application correctly.

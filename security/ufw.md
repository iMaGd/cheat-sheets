### Disable and Remove UFW

1. **Disable ufw**: Disable the `ufw` service to prevent it from starting on system boot:

   ```sh
   sudo ufw disable
   ```

2. **Stop the ufw service**: Even after disabling it, the `ufw` service might still be running. Stop it with:

   ```sh
   sudo systemctl stop ufw
   ```

3. **Mask the ufw service**: To prevent the service from being started by other services, you can mask it:

   ```sh
   sudo systemctl mask ufw
   ```

4. **Reset ufw rules**: Before you uninstall `ufw`, it's a good idea to reset the rules to defaults to clear out all of the rules that might have been set.

   ```sh
   sudo ufw reset
   ```

5. **Uninstall ufw**: If you no longer wish to have `ufw` on your system, you can uninstall it:

   ```sh
   sudo apt remove --purge ufw -y
   ```

#### In a Nutshell

```sh
sudo ufw app list
sudo ufw disable
sudo systemctl stop ufw
sudo systemctl mask ufw
sudo ufw reset -y
sudo apt remove --purge ufw -y
```
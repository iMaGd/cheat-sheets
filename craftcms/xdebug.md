# Xdebug with DDEV

DDEV makes it easy to work with Xdebug for debugging PHP inside containers.
---

# Enable Xdebug
```bash
ddev xdebug
ddev xdebug enable
```

# Disable Xdebug
```bash
ddev xdebug disable
```

# Check current status
```bash
ddev xdebug status
```

## VS Code Configuration

To allow VS Code to map project files to the container, add the following to your `launch.json` configuration:

```json
"pathMappings": {
    "/var/www/html": "${workspaceFolder}/"
}
```

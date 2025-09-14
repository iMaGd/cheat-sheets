# 📦 Version Manager Cheatsheet

This guide covers essential commands for managing versions using the following tools:

- `tfenv` (Terraform)
- `pyenv` (Python)
- `nvm` (Node.js)
- `phpenv` (PHP)
- `goenv` (Go)

---

## 1. Terraform – `tfenv`
```bash
# List installed versions
tfenv list

# List available versions
tfenv list-remote

# Install a specific version
tfenv install 1.6.6

# Switch to a version (global or local)
tfenv use 1.6.6

# Uninstall a version
tfenv uninstall 1.5.0
```

---

## 2. Python – `pyenv`
```bash
# List installed versions
pyenv versions

# List available versions
pyenv install --list

# Install a version
pyenv install 3.11.4

# Set global version
pyenv global 3.11.4

# Set version for current shell
pyenv shell 3.11.4

# Set local version (creates .python-version)
pyenv local 3.11.4

# Uninstall a version
pyenv uninstall 3.10.0
```

---

## 3. Node.js – `nvm`
```bash
# List installed versions
nvm ls

# List available versions
nvm ls-remote

# Install a version
nvm install 18

# Use a version (for current shell)
nvm use 18

# Set default version
nvm alias default 18

# Uninstall a version
nvm uninstall 16
```

---

## 4. PHP – `phpenv`
```bash
# List installed versions
phpenv versions

# List available versions
phpenv install --list

# Install a version
phpenv install 8.2.12

# Set global version
phpenv global 8.2.12

# Set local version (creates .php-version)
phpenv local 8.2.12

# Uninstall a version (manual removal)
rm -rf ~/.phpenv/versions/8.1.0
```

---

## 5. Go – `goenv`
```bash
# List installed versions
goenv versions

# List available versions
goenv install -l

# Install a version
goenv install 1.21.5

# Set global version
goenv global 1.21.5

# Set local version (creates .go-version)
goenv local 1.21.5

# Uninstall a version
goenv uninstall 1.20.0
```

---

## 🧠 Summary Table of Key Commands

| Action             | `tfenv`             | `pyenv`               | `nvm`              | `phpenv`            | `goenv`             |
|--------------------|---------------------|------------------------|--------------------|----------------------|---------------------|
| List installed     | `tfenv list`        | `pyenv versions`       | `nvm ls`           | `phpenv versions`    | `goenv versions`    |
| List available     | `tfenv list-remote` | `pyenv install --list` | `nvm ls-remote`    | `phpenv install --list` | `goenv install -l`  |
| Install version    | `tfenv install`     | `pyenv install`        | `nvm install`      | `phpenv install`     | `goenv install`     |
| Use version        | `tfenv use`         | `pyenv shell` / `local`| `nvm use`          | `phpenv local` / `global` | `goenv local` / `global` |
| Set global version | same as `use`       | `pyenv global`         | `nvm alias default`| `phpenv global`      | `goenv global`      |
| Uninstall version  | `tfenv uninstall`   | `pyenv uninstall`      | `nvm uninstall`    | *(manual delete)*    | `goenv uninstall`   |

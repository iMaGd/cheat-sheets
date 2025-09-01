# Craft CMS with DDEV -- Cheatsheet

This document is a quick reference for setting up and working with Craft
CMS projects using [DDEV](https://ddev.readthedocs.io/).

------------------------------------------------------------------------

## Starting a New Project

``` bash
# Configure project
ddev config --project-type=craftcms --docroot=web --create-docroot --project-tld=ddev --xdebug-enabled=true

# Start the project
ddev start

# Create a new Craft CMS installation
ddev composer create craftcms/craft -y

# Open project in browser
ddev launch

# Show project details
ddev describe
```

------------------------------------------------------------------------

## Using an Existing Project

``` bash
# Configure project
ddev config --project-type=craftcms --docroot=web --project-tld=ddev

# Install dependencies
ddev composer install
```

------------------------------------------------------------------------

## Working with Databases

``` bash
# MySQL
ddev mysql

# PostgreSQL
ddev psql

# Open in TablePlus
ddev tableplus

# Open in Sequel Ace
ddev sequelace
```

------------------------------------------------------------------------

## Managing NPM Packages

``` bash
# Install npm dependencies
ddev exec npm install
```

------------------------------------------------------------------------

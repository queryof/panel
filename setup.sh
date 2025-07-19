#!/bin/bash

# Set up the app folder
cd /var/www/html

# Clone Pterodactyl (or download latest)
git clone https://github.com/pterodactyl/panel.git .
composer install --no-dev --optimize-autoloader

# Permissions
chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# Sample .env if needed
cp .env.example .env

# Generate app key
php artisan key:generate

echo "✔️ Pterodactyl base installed."

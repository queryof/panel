#!/bin/bash

# Start MySQL and Redis
service mysql start
service redis-server start

# Secure MariaDB installation
mysql -e "CREATE DATABASE panel;"
mysql -e "CREATE USER 'paneluser'@'localhost' IDENTIFIED BY 'strongpassword';"
mysql -e "GRANT ALL PRIVILEGES ON panel.* TO 'paneluser'@'localhost';"
mysql -e "FLUSH PRIVILEGES;"

# Clone panel
git clone https://github.com/pterodactyl/panel.git /var/www/pterodactyl
cd /var/www/pterodactyl

# Setup Laravel
cp .env.example .env
composer install --no-dev --optimize-autoloader
php artisan key:generate

# Set DB credentials in .env
sed -i "s/DB_DATABASE=.*/DB_DATABASE=panel/" .env
sed -i "s/DB_USERNAME=.*/DB_USERNAME=paneluser/" .env
sed -i "s/DB_PASSWORD=.*/DB_PASSWORD=strongpassword/" .env

php artisan migrate --seed --force

# Set permissions
chown -R www-data:www-data /var/www/pterodactyl/storage /var/www/pterodactyl/bootstrap/cache

# Setup NGINX
cat <<EOF >/etc/nginx/sites-available/pterodactyl
server {
    listen 80;
    root /var/www/pterodactyl/public;
    index index.php index.html;
    server_name localhost;

    location / {
        try_files \$uri \$uri/ /index.php?\$query_string;
    }

    location ~ \.php\$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/run/php/php8.1-fpm.sock;
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
        include fastcgi_params;
    }
}
EOF

ln -s /etc/nginx/sites-available/pterodactyl /etc/nginx/sites-enabled/
rm /etc/nginx/sites-enabled/default
service php8.1-fpm start
service nginx restart

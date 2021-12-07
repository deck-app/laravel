#!/bin/bash

if [ -d "/var/www/vendor" ]
then
    cd /var/www/
    composer update
    echo "Dependencies updated"
elif [ "$(ls -A "/var/www/")" ]; 
then
    echo "Directory is not Empty"
else
    composer create-project --prefer-dist laravel/laravel:^8.0 .
fi
echo "Application key set ...."
composer install
if [ ! -f ".env" ]; 
then
    echo ".env file not found"
    cp .env.example .env
    php artisan key:generate
else
    echo ".env file exit"
fi
php artisan key:generate
chmod -R 777 /var/www/storage
exec "$@"
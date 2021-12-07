#!/bin/bash

if [ -d "/var/www/vendor" ]
then
    cd /var/www/
    composer update
    echo "Dependencies updated"
elif [ "$(ls -A "/var/www/")" ]; 
then
    echo "Take action $DIR is not Empty"
else
    composer create-project --prefer-dist laravel/laravel:^6.0 .
fi
echo "Application key set ...."
composer install
php artisan key:generate
chmod -R 777 /var/www/storage
exec "$@"
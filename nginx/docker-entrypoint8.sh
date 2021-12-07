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
php artisan key:generate
chmod -R 777 /var/www/storage
exec "$@"
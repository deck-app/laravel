#!/bin/bash
if [ -f "/var/www/composer.json" ]
then
    cd /var/www/
    composer install
    echo "Dependencies updated"
elif [ "$(ls -A "/var/www/")" ]; 
then
    echo "Directory is not Empty, Please deleted hiden file and directory"
elif [ {LARAVEL_INSTALL} = true ];
then   
    composer create-project --prefer-dist laravel/laravel:^7.0 .
fi
if [ ! -f ".env" ]; 
then
    echo ".env file not found"
    cp .env.example .env
else
    echo ".env file exit"
fi
echo "Application key set ...."
php artisan key:generate
chmod -R 777 /var/www/storage
exec "$@"
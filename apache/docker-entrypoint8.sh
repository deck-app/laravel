#!/bin/bash
set -e

if [[ -f "/var/www/composer.json" ]] ;
then
    cd /var/www/
    if [[ -d "/var/www/vendor" ]] ;
    then
        echo "Composer optimize autoloader"
        composer update --prefer-dist --no-interaction --optimize-autoloader --no-dev
        echo "Laravel - Clear All [Development]"
        php artisan view:clear
        php artisan route:clear
        php artisan config:clear
        php artisan clear-compiled
        chmod -R 777 /var/www/storage
    else
        echo "Composer vendor folder was not installed. Running $> composer install --prefer-dist --no-interaction --optimize-autoloader --no-dev"
        composer install --prefer-dist --no-interaction --optimize-autoloader --no-dev
        echo "Laravel - Clear All [Development]"
        php artisan view:clear
        php artisan route:clear
        php artisan config:clear
        php artisan clear-compiled
        chmod -R 777 /var/www/storage
    fi

fi
if [[ {LARAVEL_INSTALL} = false ]] ;
then
    if [[ "$(ls -A "/var/www/")" ]] ;
    then
        echo "Directory is not Empty, Please deleted hiden file and directory"
    else
        composer create-project --prefer-dist laravel/laravel:^8.0 .
        echo "Laravel - Clear All [Development]"
        php artisan view:clear
        php artisan route:clear
        php artisan config:clear
        php artisan clear-compiled
        chmod -R 777 /var/www/storage
    fi
fi
echo "Application Enverment veriable check"
if [[ ! -f ".env" ]] ;
then
    echo ".env file not found"
    cp .env.example .env
else
    echo ".env file exit"
fi
echo "Application key set ...."
php artisan key:generate
cp /app/httpd.conf /etc/apache2/httpd.conf
rm -rf /var/preview
kill -TERM `cat /var/run/apache2/httpd.pid`
httpd -k graceful

chmod -R 777 /var/www/storage
exec "$@"
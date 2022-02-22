#!/bin/bash
set +x

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
    else
        echo "Composer vendor folder was not installed. Running $> composer install --prefer-dist --no-interaction --optimize-autoloader --no-dev"
        composer install --prefer-dist --no-interaction --optimize-autoloader --no-dev
    fi

fi
if [[ {LARAVEL_INSTALL} = false ]] ;
then
    if [[ "$(ls -A "/var/www/")" ]] ;
    then
        echo "Directory is not Empty, Please deleted hiden file and directory"
    else
        composer create-project --prefer-dist laravel/laravel:^{LARAVEL_VERSION}.0 .

    fi
fi
echo "Application environment variable check"
if [[ ! -f ".env" ]] ;
then
    echo ".env file not found"
    cp .env.example .env
else
    echo ".env file exit"
fi

php artisan key:generate
cp /app/default.conf /etc/nginx/conf.d/default.conf
rm -rf /var/preview
if [ "$(stat -c '%a' /var/www/storage)" == "nobody:nobody" ]
then
  echo "Storage folder already write permissions"
else
  chown -R nobody:nobody /var/www/storage
fi
pkill -9 php
nginx -s reload

exec "$@"
#!/bin/bash
set +x

if [[ -f "/var/www/composer.json" ]] ;
then
    cd /var/www/
    if [[ -d "/var/www/vendor" ]] ;
    then
        echo "Steps to use Composer optimise autoloader"
        composer update --prefer-dist --no-interaction --optimize-autoloader --no-dev
        echo "Steps to Clear All Development inputs"
        php artisan view:clear
        php artisan route:clear
        php artisan config:clear
        php artisan clear-compiled
    else
        echo "If composer vendor folder is not installed follow the below steps"
        composer install --prefer-dist --no-interaction --optimize-autoloader --no-dev
    fi

fi
if [[ "$(ls -A "/var/www/")" ]] ;
    then
        echo "If the Directory is not empty, please delete the hidden files and directory"
    else
        composer create-project --prefer-dist laravel/laravel:^{LARAVEL_VERSION}.0 .
fi
echo "Steps to check application environment variable"
if [[ ! -f ".env" ]] ;
then
    echo ".env file not found"
    cp .env.example .env
else
    echo ".env file exit"
fi

php artisan key:generate
if [[ {BACK_END} = nginx ]] ;
then
    npm install
    npm run dev
else
    apk add yarn
    yarn install
    yarn run dev
    npm install
    npm run dev
fi

if [[ {BACK_END} = nginx ]] ;
then
    cp /app/default.conf /etc/nginx/conf.d/default.conf
    nginx -s reload
    chown -R nobody:nobody /var/www 2> /dev/null
else
    cp /app/httpd.conf /etc/apache2/httpd.conf
    httpd -k graceful
    chown -R apache:apache /var/www 2> /dev/null
fi

rm -rf /var/preview

exec "$@"
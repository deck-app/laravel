#!/bin/bash
set +x  # Disable verbose debugging output

# Check if Laravel website is accessible (indicating internet connectivity)
if [[ $(curl -Is https://laravel.com | head -n 1 | cut -d ' ' -f 2) == "200" ]]; then

    # Check if we're in a Composer project directory
    if [[ -f "/var/www/composer.json" ]]; then
        cd /var/www/  # Change to project directory

        # Check if vendor directory exists (Composer dependencies installed)
        if [[ -d "/var/www/vendor" ]]; then
            echo "Steps to use Composer optimise autoloader"
            sudo composer update --prefer-dist --no-interaction --optimize-autoloader --no-dev

            echo "Steps to Clear All Development inputs"
            sudo php artisan view:clear
            sudo php artisan route:clear
            sudo php artisan config:clear
            sudo php artisan clear-compiled
        else
            echo "If composer vendor folder is not installed follow the below steps"
            sudo composer install --prefer-dist --no-interaction --optimize-autoloader --no-dev
        fi
    fi

    # Check if the project directory is empty (excluding hidden files)
    if [[ "$(ls -A "/var/www/")" ]]; then
        echo "If the Directory is not empty, please delete the hidden files and directory"
    else
        sudo composer config --global process-timeout 6000  # Set longer timeout

        # Install Laravel based on version (or latest if not specified)
        if [[ "{LARAVEL_VERSION}" == "latest" ]]; then
            # If LARAVEL_VERSION is empty or "latest", install the latest version
            sudo composer create-project --prefer-dist laravel/laravel .
        else
            # Otherwise, install the specified version
            sudo composer create-project --prefer-dist laravel/laravel:^{LARAVEL_VERSION}.0 .
        fi

        # If Laravel installation fails, execute the default entrypoint script
        if [ $? != 0 ]; then
            sh /docker-entrypoint.sh
        fi
    fi

    echo "Steps to check application environment variable"
    # Ensure .env file exists for environment configuration
    if [[ ! -f ".env" ]]; then
        echo ".env file not found"
        sudo cp .env.example .env
    else
        echo ".env file exists"
    fi

    # Configure Nginx, set permissions, clean up
    sudo cp /app/default.conf /etc/nginx/conf.d/default.conf
    nginx -s reload  # Reload Nginx configuration
    sudo chown -R nobody:nobody /var/www 2> /dev/null  # Set ownership to Nginx user
    sudo rm -rf /var/preview 2> /dev/null

    sudo php artisan key:generate  # Generate Laravel application key

    exec "$@"  # Execute any passed arguments
else
    echo "Internet not working check your Internet connection or network";
fi

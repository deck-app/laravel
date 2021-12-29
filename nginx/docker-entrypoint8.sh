#!/bin/bash
if [[ ! -e /var/www/index.php ]] || [[ ! -e wp-includes/version.php ]] ; 
then
    echo "WordPress not found in /var/www/ - copying now..."
    rsync -aP -f'+ /*' -f'+ *' /tmp/latest/wordpress/* /var/www/
else
    echo "WordPress already install..."
fi
cp /app/default.conf /etc/nginx/conf.d/default.conf
nginx -s reload
rm -rf /var/preview
rm -rf /app
exec "$@"
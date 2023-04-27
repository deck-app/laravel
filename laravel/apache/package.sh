#!/bin/sh
word=$(echo -n "$INSTALL_ADDITIONAL_EXTENSIONS" | wc -w)
for (( n=1; n<=$word; n++ ))
do
SERVER_ARRAY=`echo ${INSTALL_ADDITIONAL_EXTENSIONS} | awk '{print $'$n'}' | sed 's/.*-//'`
sudo apk add --no-cache php${PHP_VERSION}-`echo ${SERVER_ARRAY}`
done
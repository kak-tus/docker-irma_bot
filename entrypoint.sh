#!/usr/bin/env sh

userdel www-data 2>/dev/null
groupdel www-data 2>/dev/null
groupadd -g $USER_GID www-data
useradd -d /home/www-data -g www-data -u $USER_UID www-data

if [ "$SET_CONTAINER_TIMEZONE" = "true" ]; then
    echo ${CONTAINER_TIMEZONE} >/etc/timezone \
    && ln -sf /usr/share/zoneinfo/${CONTAINER_TIMEZONE} /etc/localtime \
    && dpkg-reconfigure -f noninteractive tzdata
    echo "Container timezone set to: $CONTAINER_TIMEZONE"
else
    echo "Container timezone not modified"
fi

mkdir -p /var/run/irma
chown www-data /var/run/irma

consul-template -config /etc/service.hcl &
child=$!

trap "kill $child" INT TERM
wait "$child"

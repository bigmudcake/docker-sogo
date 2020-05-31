#!/bin/sh

# edave - Create orig config file if not exist
if [ ! -f "/etc/apache-SOGo.conf.orig" ]; then
    cp /etc/apache2/conf-available/SOGo.conf /etc/apache-SOGo.conf.orig
fi

# edave - Copy orig config files to /srv as example
mkdir -p /srv/etc
cp /etc/*.orig /srv/etc/

# Only run apache if config file exists
if [ -f "/srv/etc/apache-SOGo.conf" ]; then

    # Copy back and enable administrator's configuration
    cp /srv/etc/apache-SOGo.conf /etc/apache2/conf-enabled/SOGo.conf

    # Run apache in foreground
    APACHE_ARGUMENTS="-DNO_DETACH" exec /usr/sbin/apache2ctl start
fi

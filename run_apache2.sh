#!/bin/sh


# Only run apache if config file exists
if [ -f "/srv/etc/apache-SOGo.conf" ]; then

    # Copy back and enable administrator's configuration
    cp /srv/etc/apache-SOGo.conf /etc/apache2/conf-enabled/SOGo.conf

    # Run apache in foreground
    APACHE_ARGUMENTS="-DNO_DETACH" exec /usr/sbin/apache2ctl start
fi

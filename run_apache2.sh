#!/bin/sh

# edave - Copy back and enable administrator's udated configuration
echo "* run_apache2 - update internal apache-SOGo.conf from /srv/etc"
cp /srv/etc/apache-SOGo.conf /etc/apache2/conf-enabled/SOGo.conf

# Run apache in foreground
echo "* run_apache2 - starting server in foreground"
APACHE_ARGUMENTS="-DNO_DETACH" exec /usr/sbin/apache2ctl start

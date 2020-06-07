#!/bin/sh

# edave - Copy back administrator's configuration
cp /srv/etc/sogo.conf /etc/sogo/sogo.conf 2>/dev/null
chown sogo:sogo /etc/sogo/sogo.conf

# Create SOGo home directory if missing
mkdir -p /srv/lib/sogo
chown sogo:sogo /srv/lib/sogo

# Load crontab
cp /srv/etc/cron /etc/cron.d/sogo 2>/dev/null
chmod +x /usr/share/doc/sogo/*.sh

# edave - copy custom web server assets back to container
if [ -d "/srv/WebServerResources" ]; then
    chmod -R 0755 /srv/WebServerResources
    cp -r /srv/WebServerResources/* /usr/lib/GNUstep/SOGo/WebServerResources/
fi

# edave - if not exist copy all web server assets to srv folder
if [ ! -d "/srv/WebServerResources" ]; then
    cp -a /usr/lib/GNUstep/SOGo/WebServerResources /srv/
fi

# edave - optionally connect SOGo to memcached via a unix socket
MEMSOCKET=`-SOGoMemcachedHost /tmp/memcached.sock`
if [ "${memcached}" = "false" ]; then
    MEMSOCKET=
fi

# Run SOGo in foreground
exec /sbin/setuser sogo /usr/sbin/sogod -WONoDetach YES -WOPidFile /var/run/sogo/sogo.pid -WOLogFile /srv/sogo.log -SOGoMemcachedHost /tmp/memcached.sock ${MEMSOCKET}

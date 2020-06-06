#!/bin/sh

# edave - Create orig config files if not exist
if [ ! -f "/etc/sogo.conf.orig" ]; then
    cp /etc/cron.d/sogo /etc/cron.orig
    cp /etc/sogo/sogo.conf /etc/sogo.conf.orig
fi

# edave - Copy orig config files to /srv as example
mkdir -p /srv/etc
cp /etc/*.orig /srv/etc/

# Copy back administrator's configuration
cp /srv/etc/sogo.conf /etc/sogo/sogo.conf 2>/dev/null
chown sogo:sogo /etc/sogo/sogo.conf

# Create SOGo home directory if missing
mkdir -p /srv/lib/sogo
chown sogo:sogo /srv/lib/sogo

# Load crontab
cp /srv/etc/cron /etc/cron.d/sogo 2>/dev/null
chmod +x /usr/share/doc/sogo/*.sh

# edave - set correct access for srv folder
chown sogo:sogo /srv
chmod 0775 /srv

# edave - copy custom web server assets back to container
if [ -d "/srv/WebServerResources" ]; then
    chmod -R 0755 /srv/WebServerResources
    cp -r /srv/WebServerResources/* /usr/lib/GNUstep/SOGo/WebServerResources/
fi

# edave - if not exist copy all web server assets to srv folder
if [ ! -d "/srv/WebServerResources" ]; then
    cp -a /usr/lib/GNUstep/SOGo/WebServerResources /srv/
fi

# Run SOGo in foreground
exec /sbin/setuser sogo /usr/sbin/sogod -WONoDetach YES -WOPidFile /var/run/sogo/sogo.pid -SOGoMemcachedHost /tmp/memcached.sock

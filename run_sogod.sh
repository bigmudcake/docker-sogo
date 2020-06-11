#!/bin/sh

# edave - Copy back administrator's configuration
echo "* run_sogod - update internal sogo.conf from /srv/etc"
cp /srv/etc/sogo.conf /etc/sogo/sogo.conf 2>/dev/null
chown sogo:sogo /etc/sogo/sogo.conf

# Create SOGo home directory if missing
echo "* run_sogod - create SOGo home folder /srv/lib/sogo"
mkdir -p /srv/lib/sogo
chown sogo:sogo /srv/lib/sogo

# Load crontab
echo "* run_sogod - update internal crontab file from /srv/etc/cron"
cp /srv/etc/cron /etc/cron.d/sogo 2>/dev/null
chmod +x /usr/share/doc/sogo/*.sh

# edave - if not exist store and copy all orig web server assets to srv folder
if [ ! -d "/WebServerResources.orig" ]; then
    echo "* run_sogod - store WebServerResources files to /WebServerResources.orig"
    cp -a /usr/lib/GNUstep/SOGo/WebServerResources /WebServerResources.orig
fi
if [ -d "/WebServerResources.orig" ]; then
    echo "* run_sogod - transferring WebServerResources.orig files to /srv"
	rm -rf /srv/WebServerResources.orig 2>/dev/null
    cp -a /WebServerResources.orig /srv/
fi

# edave - copy custom web server assets back to container
if [ -d "/srv/WebServerResources" ]; then
    echo "* run_sogod - overwrite WebServerResources from custom assets in /srv/WebServerResources"
    chmod -R 0755 /srv/WebServerResources
    cp -r /srv/WebServerResources/* /usr/lib/GNUstep/SOGo/WebServerResources/
else
    echo "* run_sogod - create folder /srv/WebServerResources for custom assets"
    mkdir -p /srv/WebServerResources
fi


# edave - Run SOGo in foreground and optionally connect SOGo to memcached via a unix socket
if [ "${memcached}" = "false" ]; then
    echo "* run_sogod - starting SOGo with builtin memcached not loaded!" 
    echo "++ make sure you set an external memcache using the SOGoMemcachedHost config option ++"
    exec /sbin/setuser sogo /usr/sbin/sogod -WONoDetach YES -WOPidFile /var/run/sogo/sogo.pid -WOLogFile /srv/sogo.log
else 
    echo "* run_sogod - starting SOGo using builtin memcached via unix socket /tmp/memcached.sock"
    exec /sbin/setuser sogo /usr/sbin/sogod -WONoDetach YES -WOPidFile /var/run/sogo/sogo.pid -WOLogFile /srv/sogo.log -SOGoMemcachedHost /tmp/memcached.sock
fi

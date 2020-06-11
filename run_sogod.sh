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

# edave - backup all web server assets
if [ ! -d "/WebServerResources.orig" ]; then
    echo "* run_sogod - backup WebServerResources files to /WebServerResources.orig"
    cp -a /usr/lib/GNUstep/SOGo/WebServerResources /WebServerResources.orig
fi

# edave - process WebServerResources files 
if [ -d "/WebServerResources.orig" ]; then
    echo "* run_sogod - process WebServerResources img files"
	mkdir -p /srv/img 2>/dev/null
	rm -rf /srv/img/*.orig
    cp -a /srv/img/* /usr/lib/GNUstep/SOGo/WebServerResources/img/
    cp -a /WebServerResources.orig/img/* /srv/img/*.orig
    echo "* run_sogod - update styles.css in WebServerResources"
    cp -a /WebServerResources.orig/css/styles.css /usr/lib/GNUstep/SOGo/WebServerResources/css/
    if [ -f "/srv/custom.css" ]; then
        echo "* run_sogod - integrate /srv/custom.css into styles.css"
        cat /srv/custom.css >> /usr/lib/GNUstep/SOGo/WebServerResources/css/styles.css
    else
        echo "* run_sogod - creating empty /srv/custom.css"
        touch /srv/custom.css
    fi
fi

# edave - make sure WebServerResources files have correct permissions  
chmod -R 0755 /usr/lib/GNUstep/SOGo/WebServerResources



# edave - Run SOGo in foreground and optionally connect SOGo to memcached via a unix socket
if [ "${memcached}" = "false" ]; then
    echo "* run_sogod - starting SOGo with builtin memcached not loaded!" 
    echo "++ make sure you set an external memcache using the SOGoMemcachedHost config option ++"
    exec /sbin/setuser sogo /usr/sbin/sogod -WONoDetach YES -WOPidFile /var/run/sogo/sogo.pid -WOLogFile /srv/sogo.log
else 
    echo "* run_sogod - starting SOGo using builtin memcached via unix socket /tmp/memcached.sock"
    exec /sbin/setuser sogo /usr/sbin/sogod -WONoDetach YES -WOPidFile /var/run/sogo/sogo.pid -WOLogFile /srv/sogo.log -SOGoMemcachedHost /tmp/memcached.sock
fi

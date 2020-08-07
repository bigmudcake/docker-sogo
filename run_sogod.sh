#!/bin/sh

# edave - Copy back administrator's configuration
echo "* run_sogod - update internal sogo.conf from /srv/etc"
cp /srv/etc/sogo.conf /etc/sogo/sogo.conf 2>/dev/null
chown sogo:sogo /etc/sogo/sogo.conf

# Create SOGo home directory if missing
echo "* run_sogod - create SOGo home folder /srv/lib/home/sogo"
mkdir -p /srv/lib/home/sogo
chown sogo:sogo /srv/lib/home/sogo

# Load crontab
echo "* run_sogod - update internal crontab file from /srv/etc/cron"
cp /srv/etc/cron /etc/cron.d/sogo 2>/dev/null
chmod +x /usr/share/doc/sogo/*.sh

# edave - backup all orig web server assets to WebServerResources.orig
if [ ! -d "/WebServerResources.orig" ]; then
    echo "* run_sogod - backup WebServerResources files to /WebServerResources.orig"
    cp -a /usr/lib/GNUstep/SOGo/WebServerResources /WebServerResources.orig
fi

# edave - process WebServerResources orig img and css files 
if [ -d "/WebServerResources.orig" ]; then
    echo "* run_sogod - process WebServerResources orig img and css files"
    rm -rf /srv/img.orig 2>/dev/null
    cp -a /WebServerResources.orig/img /srv/img.orig
    echo "* run_sogod - copy orig styles.css to WebServerResources"
    cp -a /WebServerResources.orig/css/styles.css /usr/lib/GNUstep/SOGo/WebServerResources/css/
fi

# edave - integrate srv custom.css into styles.css
if [ -f "/srv/custom.css" ]; then
    echo "* run_sogod - integrate /srv/custom.css into styles.css"
    cat /srv/custom.css >> /usr/lib/GNUstep/SOGo/WebServerResources/css/styles.css
else
    echo "* run_sogod - creating empty /srv/custom.css file"
    touch /srv/custom.css
fi

# edave - process srv/img files  
if [ -d "/srv/img" ]; then
    echo "* run_sogod - copy custom srv/img files to WebServerResources"
    cp -a /srv/img/* /usr/lib/GNUstep/SOGo/WebServerResources/img/
    chmod -R 755 /usr/lib/GNUstep/SOGo/WebServerResources/img/*
else
    echo "* run_sogod - creating folder /srv/img"
    mkdir -p /srv/img
fi

# edave - copy /usr/lib/GNUstep/SOGo to srv/lib to allow access if running webserver on host only mode
# GNUstep/SOGo folder in srv/lib is regenerated on every container restart to maximise file security
echo "* run_sogod - install /usr/lib/GNUstep/SOGo to srv/lib/GNUstep/SOGo"
rm -rf /srv/lib/GNUstep 2>/dev/null
mkdir -p /srv/lib/GNUstep 2>/dev/null
cp -a /usr/lib/GNUstep/SOGo  /srv/lib/GNUstep/SOGo
chmod -R 755 /srv/lib/GNUstep


# edave - Run SOGo in foreground and optionally connect SOGo to memcached via a unix socket
if [ "${memcached}" = "false" ]; then
    echo "* run_sogod - starting SOGo with builtin memcached not loaded!" 
    echo "++ make sure you set an external memcache using the SOGoMemcachedHost config option ++"
    exec /sbin/setuser sogo /usr/sbin/sogod -WONoDetach YES -WOPidFile /var/run/sogo/sogo.pid -WOLogFile /srv/sogo.log
else 
    echo "* run_sogod - starting SOGo using builtin memcached via unix socket /tmp/memcached.sock"
    exec /sbin/setuser sogo /usr/sbin/sogod -WONoDetach YES -WOPidFile /var/run/sogo/sogo.pid -WOLogFile /srv/sogo.log -SOGoMemcachedHost /tmp/memcached.sock
fi

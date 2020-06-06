#!/bin/sh

# edave - Make GATEWAY host available
GATEWAY=`ip route show 0.0.0.0/0 | awk '{print $3}'`
echo "${GATEWAY} GATEWAY" >> /etc/hosts

# edave - setup necessary subfolders and permissions
mkdir -p /srv/etc
chown -R sogo:sogo /srv
chmod -R 775 /srv
chmod -R 775 /var/log
chmod -R 775 /runfiles

# edave - Create orig config files if not exist
if [ ! -f "/etc/sogo.conf.orig" ]; then
    cp /etc/cron.d/sogo /etc/cron.orig
    cp /etc/apache2/conf-available/SOGo.conf /etc/apache-SOGo.conf.orig
    cp /etc/sogo/sogo.conf /etc/sogo.conf.orig
fi

# edave - Copy orig config files to /srv as config examples
cp /etc/*.orig /srv/etc/

# edave - setup main SOGo service daemon from runfiles
rm -rf /etc/service/sogod
mkdir -p /etc/service/sogod
cp /runfiles/run_sogod.sh /etc/service/sogod/run

# edave - setup optional memcached service daemon from runfiles
rm -rf /etc/service/memcached
if [ ! "${memcached}" = "false" ]; then
    mkdir -p /etc/service/memcached
    cp /runfiles/run_memcached.sh /etc/service/memcached/run
fi

# edave - setup optional apache2 service daemon from runfiles
rm -rf /etc/service/apache2
if [ -f /srv/etc/apache-SOGo.conf ]; then
    mkdir -p /etc/service/apache2
    cp /runfiles/run_apache2.sh /etc/service/apache2/run
fi

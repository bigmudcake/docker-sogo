#!/bin/sh

# edave - Make GATEWAY host available
GATEWAY=`ip route show 0.0.0.0/0 | awk '{print $3}'`
echo "${GATEWAY} GATEWAY" >> /etc/hosts

# edave - setup necessary srv subfolders and permissions
mkdir -p /srv/etc
chown -R sogo:sogo /srv
chmod -R 775 /srv

# edave - allow log files to be viewed by non-root users
chmod -R 775 /var/log


# edave - enable/disable execute startup for memcached
if [ "${memcached}" = "false" ]; then
        MOD=-x
else
        MOD=+x
fi
chmod ${MOD} /etc/service/memcached/run

# edave - enable/disable execute startup for Apache Web Server
if [ -f /srv/etc/apache-SOGo.conf ]; then
        MOD=+x
else
        MOD=-x
fi
chmod ${MOD} /etc/service/apache2/run

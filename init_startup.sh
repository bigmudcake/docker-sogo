#!/bin/sh

# edave - Make GATEWAY host available
GATEWAY=`ip route show 0.0.0.0/0 | awk '{print $3}'`
echo "${GATEWAY} GATEWAY" >> /etc/hosts

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

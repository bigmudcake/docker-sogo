#!/bin/sh

if [ "${memcached}" = "false" ]; then
        MOD=-x
else
        MOD=+x
fi
chmod ${MOD} /etc/service/memcached/run

if [ -f /srv/etc/apache-SOGo.conf ]; then
        MOD=+x
else
        MOD=-x
fi
chmod ${MOD} /etc/service/apache2/run

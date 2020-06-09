#!/bin/sh

# edave - start memcached daemon
echo "* run_memcached - starting daemon with -m ${memcached:-64}"
exec /sbin/setuser sogo /usr/bin/memcached -m ${memcached:-64} -s /tmp/memcached.sock -a 0700 >> /srv/memcached.log 2>&1

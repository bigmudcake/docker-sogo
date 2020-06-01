#!/bin/sh

# edave - setup log file folder within srv folder
mkdir -p /srv/log

# edave - start memcached daemon
exec /sbin/setuser sogo /usr/bin/memcached -m ${memcached:-64} -s /tmp/memcached.sock -a 0700 >>/srv/log/memcached.log 2>&1

#!/bin/sh
exec /sbin/setuser sogo /usr/bin/memcached -m ${memcached:-64} -s /tmp/memcached.sock -a 0700 >>/srv/log/memcached.log 2>&1

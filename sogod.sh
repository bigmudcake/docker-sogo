#!/bin/sh

# Copy distribution config files to /srv as example
mkdir -p /srv/etc
cp /etc/sogo/sogo.conf /srv/etc/sogo.conf.orig

# Copy back administrator's configuration
cp /srv/etc/sogo.conf /etc/sogo/sogo.conf
chown sogo:sogo /etc/sogo/sogo.conf

# Create SOGo home directory if missing
mkdir -p /srv/lib/sogo
chown sogo:sogo /srv/lib/sogo

# Copy crontab to /srv as example
cp /etc/cron.d/sogo /srv/etc/cron.orig

# Load crontab
cp /srv/etc/cron /etc/cron.d/sogo
chmod +x /usr/share/doc/sogo/*.sh

# edave - set correct access for srv folder
chown sogo:sogo /srv
chmod 0775 /srv

# edave - setup log file within srv folder
mkdir -p /srv/log
chown -R sogo:sogo /srv/log
chmod -R 0755 /srv/log

# Run SOGo in foreground
exec /sbin/setuser sogo /usr/sbin/sogod -WONoDetach YES -WOPidFile /var/run/sogo/sogo.pid -WOLogFile /srv/log/sogo.log

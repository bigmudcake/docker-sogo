FROM            phusion/baseimage:bionic-1.0.0

# Get phusion/baseimage version tag from 
##  https://hub.docker.com/r/phusion/baseimage/tags/
##  https://github.com/phusion/baseimage-docker/blob/master/Changelog.md

# Fix SoGo package install bug 4776 - https://sogo.nu/bugs/view.php?id=4776
RUN mkdir -p /usr/share/doc/sogo && \
    touch /usr/share/doc/sogo/empty.sh 

# Install Apache, SOGo from repository
RUN echo "deb http://packages.inverse.ca/SOGo/nightly/4/ubuntu/ bionic bionic" > /etc/apt/sources.list.d/SOGo.list && \
    apt-key adv --keyserver "hkps.pool.sks-keyservers.net" --recv-key 0x810273C4 && \
    apt-get update && \
    apt-get install -y --no-install-recommends gettext-base iproute2 net-tools apache2 sogo sogo-activesync sope4.9-gdl1-mysql memcached ping traceroute && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Activate required Apache modules
RUN a2enmod headers proxy proxy_http rewrite ssl

# Move SOGo's data directory to /srv
RUN usermod --home /srv/lib/sogo sogo

# edave - add run daemons
RUN mkdir -p /runfiles
ADD run_*.sh /runfiles/

# Install startup script
RUN mkdir -p /etc/my_init.d
ADD init_startup.sh /etc/my_init.d/
RUN chmod 0755 /etc/my_init.d/init_startup.sh

# Interface the environment
VOLUME /srv /var/log
EXPOSE 80 443 8800 20000
# USER sogo

# Baseimage init process
ENTRYPOINT ["/sbin/my_init"]

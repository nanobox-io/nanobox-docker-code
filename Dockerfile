FROM nanobox/base

# Copy files
ADD hookit/. /opt/gonano/hookit/mod/

# TEMP? 'mount' data dir
RUN mkdir -p /data

# Install pkgin packages
RUN curl -k http://pkgsrc.nanobox.io/nanobox/base/Linux/bootstrap.tar.gz | gunzip -c | tar -C / -xf -
RUN echo "http://pkgsrc.nanobox.io/nanobox/base/Linux/" > /data/etc/pkgin/repositories.conf
#TEMP
# RUN echo "http://packages.pagodabox.io/pkgsrc/public/Linux/x86_64/All/" >> /data/etc/pkgin/repositories.conf
RUN mkdir -p /data/var/db/pkgin
RUN rm -rf /data/var/db/pkgin && /data/bin/pkgin -y up

# Cleanup disk
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /data/var/db/pkgin

# Allow ssh
EXPOSE 22

# Run runit automatically
CMD /sbin/my_init

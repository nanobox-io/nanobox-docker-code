FROM nanobox/base

# Create directories
RUN mkdir -p /var/log/gonano

# Copy files
ADD hookit/. /opt/gonano/hookit/mod/

# Cleanup disk
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /data/var/db/pkgin

# Allow ssh
EXPOSE 22

# Run runit automatically
CMD /sbin/my_init

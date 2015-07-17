FROM nanobox/runit

# Create directories
RUN mkdir -p /var/log/gonano
RUN mkdir -p /opt/bin

# Copy files
ADD hookit/. /opt/gonano/hookit/mod/
ADD files/opt/bin/. /opt/bin/

# Allow nfs mounts
RUN apt-get update -qq && \
    apt-get install -y nfs-common && \
    apt-get clean all && \
    rm -rf /var/lib/apt/lists/*

# Cleanup disk
RUN rm -rf /tmp/* /var/tmp/*

# Run runit automatically
CMD /sbin/my_init

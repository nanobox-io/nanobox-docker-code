FROM nanobox/runit

# Create directories
RUN mkdir -p /var/log/gonano
RUN mkdir -p /opt/bin

# Copy files
ADD hookit/. /opt/gonano/hookit/mod/
ADD files/opt/bin/. /opt/bin/

# remove pkgsrc base bootstrap to save space
# since it's replaced by the build and not used
RUN rm -rf /data && \
    mkdir -p /data

# Allow nfs mounts
RUN apt-get update -qq && \
    apt-get install -y nfs-common && \
    apt-get clean all && \
    rm -rf /var/lib/apt/lists/*

# Cleanup disk
RUN rm -rf /tmp/* /var/tmp/*

# Run runit automatically
CMD /opt/gonano/bin/nanoinit

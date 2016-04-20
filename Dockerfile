FROM nanobox/runit

# Install nfs client
RUN apt-get update -qq && \
    apt-get install -y nfs-common && \
    apt-get clean all && \
    rm -rf /var/lib/apt/lists/*

# remove pkgsrc base bootstrap to save space
# since it's replaced by the build and not used
RUN rm -rf /data && \
    mkdir -p /data

# Created necessary directories
RUN mkdir -p /opt/nanobox

# Copy files
ADD files/opt/nanobox/. /opt/nanobox/

# Run runit automatically
CMD [ "/opt/gonano/bin/nanoinit" ]

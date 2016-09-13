#!/bin/bash
#
# Launch a container and console into it, providing a complete sandbox environment

# start a container for a sandbox
echo "Launching a sandbox container..."
docker run \
  --name=sandbox \
  -d \
  --privileged \
  --net=nanobox \
  --ip=192.168.0.55 \
  nanobox/code

# hop into the sandbox
echo "Consoling into the sandbox..."
docker exec -it sandbox bash

# remove the sandbox
echo "Destroying the sandbox container..."
docker stop sandbox
docker rm sandbox

echo "Bye."

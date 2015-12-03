#!/bin/bash

CONTAINER=nginx-proxy
START_WITH_DOCKER=false

# ------------------------------------------------------

set -e
cd `dirname $0`

if [ ! -f "$PWD/proxy.conf" ]; then
    echo "Error: you need to create `dirname $0`/proxy.conf in order to use nginx-proxy"
    exit 1
fi

if [[ "`docker ps -aq --filter="name=$CONTAINER"`" != "" ]]; then
  echo "Removing existing $CONTAINER container."
  docker rm -f $CONTAINER > /dev/null
fi
if [[ "$START_WITH_DOCKER" = true ]]; then
  START_WITH_DOCKER_CMD="--restart=always"
fi

# ------------------------------------------------------

echo "Starting $CONTAINER."

CMD="
  docker run -d
    $START_WITH_DOCKER_CMD
    --restart=always
    --name $CONTAINER
    -p 80:80
    -v /var/run/docker.sock:/var/run/docker.sock:ro
    -v $PWD/proxy.conf:/proxy.conf
    ball6847/nginx-proxy
"

$CMD > /dev/null

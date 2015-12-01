#!/bin/sh

CONTAINER=nginx-proxy

cd `dirname $0`

if [[ ! -f "$PWD/proxy.conf" ]]; then
    echo "Error: you need to create $PWD/proxy.conf in order to use nginx-proxy"
    exit 1
fi

docker rm -f $CONTAINER > /dev/null 2>&1

docker run -d \
    --restart=always \
    --name $CONTAINER \
    -p 80:80 \
    -v /var/run/docker.sock:/var/run/docker.sock:ro \
    -v $PWD/proxy.conf:/proxy.conf \
    ball6847/nginx-proxy

#!/usr/bin/env bash

set -e

getenv(){
    local _env="$(printenv $1)"
    echo "${_env:-$(cat .env | awk 'BEGIN { FS="="; } /^'$1'/ {sub(/\r/,"",$2); print $2;}')}"
}

REGISTRY_URL="$(getenv REGISTRY_URL)"
CONTAINER_ID_FILE=/var/run/fb.did

if [ -f "$CONTAINER_ID_FILE" ]; then
    DID=`cat "$CONTAINER_ID_FILE"`
fi

SCRIPT_BASE_PATH=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd "$SCRIPT_BASE_PATH"

usage() {
echo "Usage:  $(basename "$0") [MODE] [OPTIONS] [COMMAND]"
echo
echo "This script is for docker 1.7 to use with Centos/RedHat 6 only!"
echo "Download and install docker 1.7.1:"
echo "$ sudo -i"
echo "# wget https://s3.ap-northeast-2.amazonaws.com/sangah-b1/docker-engine-1.7.1-1.el6.x86_64.rpm"
echo "# yum localinstall --nogpgcheck docker-engine-1.7.1-1.el6.x86_64.rpm"
echo "# service docker start"
echo "# exit"
echo
echo "Commands:"
echo "  up              Start the services"
echo "  down            Stop the services"
echo "  restart         Restart the services"
echo "  logs            Follow the logs on console"
echo "  login           Log in to a Docker registry"
echo "  remove-all      Remove all containers"
echo "  stop-all        Stop all containers running"
echo
}

if [ $# -eq 0 ]; then
    usage
    exit 1
fi

if ! command -v docker >/dev/null 2>&1; then
    usage
    exit 1
fi

echo "Arguments: $CONF_ARG"
echo "Command: $@"

if [ "$1" == "login" ]; then
    docker login $REGISTRY_URL
    exit 0

elif [ "$1" == "up" ]; then
    docker pull $REGISTRY_URL/sensu-client
    docker run \
    --volume "/var/run/docker.sock:/var/run/docker.sock" \
    --volume "$PWD/sensu-client/plugins:/etc/sensu/plugins" \
    --env "LOGSPOUT=ignore" \
    --env "SENSU_HOST=${SENSU_HOST}" \
    --env "SENSU_USER=${SENSU_USER}" \
    --env "SENSU_PASSWORD=${SENSU_PASSWORD}" \
    --env "CLIENT_NAME=${CLIENT_NAME}" \
    --env "CLIENT_IP=${CLIENT_IP}" \
    --detach=true \
    --restart=always \
    --privileged \
    --log-driver json-file \
    --log-opt max-size=10m \
    --log-opt max-file=5 \
    $REGISTRY_URL/filebeat > $CONTAINER_ID_FILE
    exit 0

elif [ "$1" == "down" ]; then
    shift
    docker stop $DID >/dev/null && docker rm $DID
    exit 0

elif [ "$1" == "stop-all" ]; then
    if [ -n "$(docker ps -q)" ]
    then docker stop $(docker ps -q); fi
    exit 0

elif [ "$1" == "remove-all" ]; then
    if [ -n "$(docker ps -a -q)" ]
    then docker rm $(docker ps -a -q); fi
    exit 0

elif [ "$1" == "logs" ]; then
    shift
    docker logs -f --tail 200 $DID
    exit 0
    
fi

docker "$@" $DID

exit $?
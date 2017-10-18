#!/bin/sh

set -e

/opt/sensu/bin/sensu-client &
status=$?
if [ $status -ne 0 ]; then
  echo "Failed to start sensu client: $status"
  exit $status
fi

while /bin/true; do
  sleep 60
done
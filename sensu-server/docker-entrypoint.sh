#!/bin/sh

set -e

# replace rabbitMQ credentials
sed -i s/RABBITMQ_USER/${SENSU_USER}/g /etc/sensu/conf.d/rabbitmq.json
sed -i s/RABBITMQ_PWD/${SENSU_PASSWORD}/g /etc/sensu/conf.d/rabbitmq.json

sed -i s/RABBITMQ_USER/${SENSU_USER}/g /etc/rabbitmq/rabbitmq.config
sed -i s/RABBITMQ_PWD/${SENSU_PASSWORD}/g /etc/rabbitmq/rabbitmq.config

/etc/init.d/redis-server start
status=$?
if [ $status -ne 0 ]; then
  echo "Failed to start redis: $status"
  exit $status
fi

/etc/init.d/rabbitmq-server start
# rabbitmqctl add_vhost /sensu
# rabbitmqctl add_user sensu secret
# rabbitmqctl set_permissions -p /sensu sensu ".*" ".*" ".*"
status=$?
if [ $status -ne 0 ]; then
  echo "Failed to start rabbitmq: $status"
  exit $status
fi

/opt/sensu/bin/sensu-server &
status=$?
if [ $status -ne 0 ]; then
  echo "Failed to start sensu server: $status"
  exit $status
fi

/opt/sensu/bin/sensu-api &
status=$?
if [ $status -ne 0 ]; then
  echo "Failed to start sensu api: $status"
  exit $status
fi

while /bin/true; do
  sleep 60
done
FROM $REGISTRY_URL/sensu-server

COPY ./config/client.json /etc/sensu/conf.d/

COPY ./docker-entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
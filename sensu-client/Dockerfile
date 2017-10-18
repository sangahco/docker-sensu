FROM dev.sangah.com:5043/sensu-server:dev

COPY ./config/ /tmp/sensu/conf.d/

RUN set -ex && \
    apt-get update && apt-get install -y \
        netcat-openbsd \
        python && \
    # install plugins
    sensu-install -p sensu-plugins-disk-checks

COPY ./docker-entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
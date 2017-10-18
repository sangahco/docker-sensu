FROM dev.sangah.com:5043/sensu-server

COPY ./config/ /tmp/sensu/conf.d/

RUN set -ex && \
    apt-get update && apt-get install -y \
        netcat-openbsd \
        python

ENV PATH /etc/sensu/plugins:$PATH

COPY ./docker-entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
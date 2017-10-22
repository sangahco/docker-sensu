FROM debian:jessie-slim
LABEL Author="Emanuele Disco <emanuele.disco@gmail.com>"

COPY ./config/ /usr/local/src/

ENV CODENAME=jessie \
    SENSU_CONFIG_DIR=/etc/sensu/conf.d \
    SENSU_PLUGIN_DIR=/etc/sensu/plugins \
    SENSU_HOME_DIR=/opt/sensu \
    SENSU_USER=sensu \
    SENSU_PASSWORD=secret

# install redis
RUN set -ex && \
    apt-get update && apt-get -y install \
        ca-certificates \
        redis-server \
        curl \
        wget \
        apt-transport-https && \
    mkdir -p $SENSU_CONFIG_DIR && \
    cp /usr/local/src/redis.json $SENSU_CONFIG_DIR && \
    echo "ULIMIT=65536" >> /etc/default/redis-server


# install rabbitMQ
RUN set -ex && \
    cd /usr/local/src && \
    curl http://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb -o erlang-solutions.deb && \
    dpkg -i erlang-solutions.deb && \
    apt-get update && apt-get -y install \
            socat \
            erlang-nox \
            logrotate && \
    curl http://www.rabbitmq.com/releases/rabbitmq-server/v3.6.9/rabbitmq-server_3.6.9-1_all.deb -o rabbitmq-server.deb && \
    dpkg -i rabbitmq-server.deb && \
    cp /usr/local/src/rabbitmq.json $SENSU_CONFIG_DIR && \
    cp /usr/local/src/rabbitmq.config /etc/rabbitmq/ && \
    echo "ulimit -n 65536" >> /etc/default/rabbitmq-server

# install sensu
RUN set -ex && \
    cd /usr/local/src && \
    wget -q https://sensu.global.ssl.fastly.net/apt/pubkey.gpg -O- | apt-key add - && \
    echo "deb https://sensu.global.ssl.fastly.net/apt $CODENAME main" | tee /etc/apt/sources.list.d/sensu.list && \
    apt-get update && apt-get install -y sensu && \
    cp /usr/local/src/transport.json $SENSU_CONFIG_DIR && \
    cp /usr/local/src/api.json $SENSU_CONFIG_DIR && \
    cp /usr/local/src/handlers.json $SENSU_CONFIG_DIR

# cleanup
RUN rm -rf /usr/local/src && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

EXPOSE 4567 5672 15672

HEALTHCHECK --interval=60s CMD curl --fail http://127.0.0.1:4567/health || exit 1

ENV PATH $SENSU_PLUGIN_DIR:$SENSU_HOME_DIR/embedded/bin:$PATH

COPY ./docker-entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
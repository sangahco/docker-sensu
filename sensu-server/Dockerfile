FROM debian:jessie-slim
LABEL Author="Emanuele Disco <emanuele.disco@gmail.com>"

COPY ./config/ /usr/local/src/

ENV CODENAME=jessie

# install redis
RUN set -ex && \
    apt-get update && apt-get -y install \
        redis-server \
        curl \
        wget \
        apt-transport-https && \
    apt-get clean && \
    mkdir -p /etc/sensu/conf.d && \
    cp /usr/local/src/redis.json /etc/sensu/conf.d/ && \
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
    cp /usr/local/src/rabbitmq.json /etc/sensu/conf.d/ && \
    cp /usr/local/src/rabbitmq.config /etc/rabbitmq/ && \
    echo "ulimit -n 65536" >> /etc/default/rabbitmq-server

# install sensu
RUN set -ex && \
    cd /usr/local/src && \
    wget -q https://sensu.global.ssl.fastly.net/apt/pubkey.gpg -O- | apt-key add - && \
    echo "deb https://sensu.global.ssl.fastly.net/apt $CODENAME main" | tee /etc/apt/sources.list.d/sensu.list && \
    apt-get update && apt-get install -y sensu && \
    cp /usr/local/src/transport.json /etc/sensu/conf.d/ && \
    cp /usr/local/src/api.json /etc/sensu/conf.d/

# remove the src folder
RUN rm -rf /usr/local/src && \
    rm -rf /var/lib/apt/lists/*

EXPOSE 3000 4567 5672 15672

COPY ./docker-entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
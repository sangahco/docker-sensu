FROM usman/sensu-client

#COPY ./load-docker-metrics.sh /etc/sensu/plugins/

RUN set -ex && \
    chmod +x /etc/sensu/plugins/*.sh || true && \
    yum install -y nc && \
    chmod 666 /var/run/docker.sock || true
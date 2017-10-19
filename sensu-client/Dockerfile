FROM dev.sangah.com:5043/sensu-server
LABEL Author="Emanuele Disco <emanuele.disco@gmail.com>"

RUN set -ex && \
    apt-get update && apt-get install -y \
        #netcat-openbsd \
        python3 && \
    ln -s /usr/bin/python3 /usr/bin/python && \
    mkdir -p /usr/local/src && \
    curl https://bootstrap.pypa.io/get-pip.py -o /usr/local/src/get-pip.py && \
    python3 /usr/local/src/get-pip.py --user && \
    ~/.local/bin/pip install requests_unixsocket && \
    # install plugins
    sensu-install -p sensu-plugins-disk-checks && \
    # cleanup
    rm -rf /usr/local/src && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY ./config/ /tmp/sensu/conf.d/
COPY ./plugins/*.py /etc/sensu/plugins/

COPY ./docker-entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
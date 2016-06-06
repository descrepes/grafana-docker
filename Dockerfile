FROM debian:jessie

ARG GRAFANA_VERSION

RUN apt-get update && \
    apt-get -y --no-install-recommends install libfontconfig curl ca-certificates python python-dev procps git && \
    apt-get clean && \
    curl https://grafanarel.s3.amazonaws.com/builds/grafana_${GRAFANA_VERSION}_amd64.deb > /tmp/grafana.deb && \
    dpkg -i /tmp/grafana.deb && \
    rm /tmp/grafana.deb && \
    curl -L https://github.com/tianon/gosu/releases/download/1.7/gosu-amd64 > /usr/sbin/gosu && \
    chmod +x /usr/sbin/gosu && \
    curl https://bootstrap.pypa.io/get-pip.py | python && \
    pip install envtpl && \
    grafana-cli plugins install grafana-clock-panel && \
    grafana-cli plugins install raintank-worldping-app && \
    grafana-cli plugins install grafana-piechart-panel && \
    grafana-cli plugins install grafana-worldmap-panel && \
    git clone https://github.com/wevanscfi/grafana-newrelic-apm-datasource /tmp/grafana-newrelic-apm-datasource && \
    mv /tmp/grafana-newrelic-apm-datasource/dist /usr/share/grafana/public/app/plugins/datasource/newrelic && \
    apt-get remove -y python-dev git && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/grafana-newrelic-apm-datasource

VOLUME ["/var/lib/grafana", "/var/lib/grafana/plugins", "/var/log/grafana", "/etc/grafana"]

EXPOSE 3000

ENV INFLUXDB_HOST localhost
ENV INFLUXDB_PORT 8086
ENV INFLUXDB_PROTO http
ENV INFLUXDB_USER grafana
ENV INFLUXDB_PASS changeme
ENV GRAFANA_USER admin
ENV GRAFANA_PASS changeme

COPY ./grafana.ini /usr/share/grafana/conf/defaults.ini.tpl
COPY ./config-*.js /etc/grafana/
COPY ./run.sh /run.sh

ENTRYPOINT ["/run.sh"]

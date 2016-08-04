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
    grafana-cli plugins install abhisant-druid-datasource && \
    grafana-cli plugins install alexanderzobnin-zabbix-app && \
    grafana-cli plugins install bosun-app && \
    grafana-cli plugins install bosun-datasource && \
    grafana-cli plugins install crate-datasource && \
    grafana-cli plugins install fastweb-openfalcon-datasource && \
    grafana-cli plugins install fetzerch-sunandmoon-datasource && \
    grafana-cli plugins install grafana-clock-panel && \
    grafana-cli plugins install grafana-influxdb-08-datasource && \
    grafana-cli plugins install grafana-kairosdb-datasource && \
    grafana-cli plugins install grafana-piechart-panel && \
    grafana-cli plugins install grafana-simple-json-datasource && \
    grafana-cli plugins install grafana-worldmap-panel && \
    grafana-cli plugins install kentik-app && \
    grafana-cli plugins install mtanda-heatmap-epoch-panel && \
    grafana-cli plugins install mtanda-histogram-panel && \
    grafana-cli plugins install ns1-app && \
    grafana-cli plugins install opennms-datasource && \
    grafana-cli plugins install percona-percona-app && \
    grafana-cli plugins install praj-ams-datasource && \
    grafana-cli plugins install raintank-snap-app && \
    grafana-cli plugins install raintank-worldping-app && \
    grafana-cli plugins install sileht-gnocchi-datasource && \
    grafana-cli plugins install stagemonitor-elasticsearch-app && \
    grafana-cli plugins install udoprog-heroic-datasource && \
    grafana-cli plugins install voxter-app && \
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
ENV GRAFANA_SESSION_PROVIDER file
ENV GRAFANA_SESSION_PROVIDER_CONFIG sessions

COPY ./grafana.ini /usr/share/grafana/conf/defaults.ini.tpl
COPY ./config-*.js /etc/grafana/
COPY ./run.sh /run.sh

ENTRYPOINT ["/run.sh"]

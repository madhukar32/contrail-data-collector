FROM phusion/baseimage:latest
MAINTAINER Madhukar <mnayakbomman@juniper.net>
MAINTAINER Vivek <vshenoy@juniper.net>

ENV INFLUXDB_VERSION 1.1.1
ENV GRAFANA_VERSION 4.0.2-1481203731

RUN   apt-get -y update && \
      apt-get -y install \
      build-essential \
      wget \
      software-properties-common

### Installation of Influxdb ###
RUN   curl -s -o /tmp/influxdb_latest_amd64.deb https://dl.influxdata.com/influxdb/releases/influxdb_${INFLUXDB_VERSION}_amd64.deb && \
      dpkg -i /tmp/influxdb_latest_amd64.deb && \
      rm /tmp/influxdb_latest_amd64.deb

RUN   mkdir /etc/service/influxdb

ADD   influxdb/types.db /usr/share/collectd/types.db
ADD   influxdb/influxdb-config.toml /config/influxdb-config.toml
ADD   influxdb/run.sh /influxdb-run.sh
ADD   influxdb/influxdb-launcher.sh /etc/service/influxdb/run

### End ###

### Installation of GRAFANA ###
RUN   mkdir -p /src/grafana  && \
      mkdir -p /opt/grafana  && \
      wget https://grafanarel.s3.amazonaws.com/builds/grafana-${GRAFANA_VERSION}.linux-x64.tar.gz -O /src/grafana.tar.gz  &&\
      tar -xzf /src/grafana.tar.gz -C /opt/grafana --strip-components=1 &&\
      rm /src/grafana.tar.*

RUN   /opt/grafana/bin/grafana-cli plugins install grafana-piechart-panel

ADD   grafana/conf.ini /opt/grafana/conf/custom.ini
ADD   grafana/run.sh  /etc/service/grafana/run
ADD   grafana/init.sh /etc/my_init.d/grafana.init.sh

RUN   mkdir /src/dashboards && \
      mkdir /opt/grafana/data && \
      chown -R www-data /opt/grafana/data
### End ###


RUN   chmod +x /etc/my_init.d/grafana.init.sh &&\
      chmod +x /etc/service/influxdb/run      &&\
      chmod +x /etc/service/grafana/run       &&\
      chmod +x /influxdb-run.sh

WORKDIR /
ENV   HOME /root
ENV   SSL_SUPPORT **False**
ENV   SSL_CERT **None**
RUN   chmod -R 777 /var/log/

### GRAFANA Ports
EXPOSE  80
EXPOSE  3000

### Influxdb Admin server WebUI
EXPOSE  8083
EXPOSE  8086

RUN   apt-get clean   &&\
      rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

CMD   ["/sbin/my_init"]

#!/usr/bin/env bash

docker run -t --name speedflux \
  -e 'INFLUX_DB_ADDRESS'='influxdb.ferg.al' \
  -e 'INFLUX_DB_PORT'='443' \
  -e 'INFLUX_DB_USER'='admin' \
  -e 'INFLUX_DB_PASSWORD'='g_~HUzM;{^ik^%U|WM4!' \
  -e 'INFLUX_DB_DATABASE'='speedtests' \
  -e 'SPEEDTEST_INTERVAL'='5' \
  -e 'SPEEDTEST_FAIL_INTERVAL'='5' \
  -e 'SPEEDTEST_SERVER_ID'='12746' \
  -e 'LOG_TYPE'='info' \
  breadlysm/speedtest-to-influxdb

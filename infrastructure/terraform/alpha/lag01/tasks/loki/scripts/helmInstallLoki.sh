#!/bin/bash

set -x

helm upgrade --install -n loki promtail grafana/promtail \
  --set "loki.serviceName=loki" \
  --set "config.lokiAddress=http://loki:3100/loki/api/v1/push" \

envsubst < conf/loki-values.yml | \
helm upgrade --install loki -n loki grafana/loki -f -

helm upgrade --install grafana -n loki -f conf/grafana-values.yml grafana/grafana

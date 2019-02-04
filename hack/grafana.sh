#!/usr/bin/env bash

set -eu -o pipefail

kubectl get secret -n prometheus-operator prometheus-operator-grafana -o yaml | grep password | awk '{print $2}' | base64 -D | pbcopy

echo grafana admin password copied to clipboard

echo forwarding to grafana on localhost:8080

open http://localhost:8080

kubectl port-forward -n prometheus-operator svc/prometheus-operator-grafana 8080:80

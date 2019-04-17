#!/usr/bin/env bash

set -eu -o pipefail

if [[ -z ${MYSQL_TOPOLOGY_PASSWORD} ]]; then
  echo '$MYSQL_TOPOLOGY_PASSWORD must be set' && exit 1
fi

RELEASE=mysql-operator

/builder/helm.bash \
    repo add \
    presslabs https://presslabs.github.io/charts

/builder/helm.bash \
    upgrade \
    --install $RELEASE \
    --debug \
    --force \
    --namespace mysql-operator \
    -f ./mysql-operator/values.yaml \
    --set orchestrator.topologyPassword=${MYSQL_TOPOLOGY_PASSWORD}
    presslabs/mysql-operator

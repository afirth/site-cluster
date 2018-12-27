#!/usr/bin/env bash

set -eu -o pipefail

if [[ -z ${HOSTNAME} ]]; then
  echo '$HOSTNAME must be set' && exit 1
fi
if [[ -z ${WP_PASSWORD} ]]; then
  echo '$WP_PASSWORD must be set' && exit 1
fi

/builder/helm.bash \
    upgrade \
    --install $HOSTNAME \
    --dry-run \
    --debug \
    --force \
    --namespace wordpress \
    -f ./wordpress/values.yaml \
    --set wordpressPassword=${WP_PASSWORD} \
    --set mariadb.mariadbRootPassword=${WP_PASSWORD} \
    --set ingress.hosts[0].name=$HOSTNAME \
    --set ingress.hosts[0].annotations."external-dns\.alpha\.kubernetes\.io/hostname"=$HOSTNAME \
    --set affinity.podAntiAffinity.preferredDuringSchedulingIgnoredDuringExecution[0].podAffinityTerm.labelSelector.matchLabels."app\.kubernetes\.io/instance"=$HOSTNAME \
    stable/wordpress

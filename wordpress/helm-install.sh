#!/usr/bin/env bash

set -eu -o pipefail

if [[ -z ${HOSTNAME} ]]; then
  echo '$HOSTNAME must be set' && exit 1
fi
if [[ -z ${WP_PASSWORD} ]]; then
  echo '$WP_PASSWORD must be set' && exit 1
fi
if [[ -z ${MARIADB_ROOT_PASSWORD} ]]; then
  echo '$MARIADB_ROOT_PASSWORD must be set' && exit 1
fi
if [[ -z ${MARIADB_USER_PASSWORD} ]]; then
  echo '$MARIADB_USER_PASSWORD must be set' && exit 1
fi

#release name from hostname
RELEASE=$(echo $HOSTNAME | tr . -)

/builder/helm.bash \
    upgrade \
    --install $RELEASE \
    --debug \
    --force \
    --namespace wordpress \
    -f ./wordpress/values.yaml \
    --set mariadb.rootUser.password=${MARIADB_ROOT_PASSWORD} \
    --set mariadb.db.password=${MARIADB_USER_PASSWORD} \
    --set wordpressPassword=${WP_PASSWORD} \
    --set ingress.hosts[0].name=$HOSTNAME \
    --set ingress.hosts[0].annotations."external-dns\.alpha\.kubernetes\.io/hostname"=$HOSTNAME \
    --set affinity.podAntiAffinity.requiredDuringSchedulingIgnoredDuringExecution[0].labelSelector.matchLabels.release=$RELEASE \
    --set affinity.podAntiAffinity.requiredDuringSchedulingIgnoredDuringExecution[0].labelSelector.matchLabels.app=$RELEASE-wordpress \
    stable/wordpress

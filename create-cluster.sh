#!/usr/bin/env bash
set -eux -o pipefail

. env.sh

gcloud beta container \
  --project "${PROJECT}" clusters create "${NAME}" \
  --zone "${REGION}-${ZONE_SUFFIX}" \
  --no-enable-basic-auth \
  --no-issue-client-certificate \
  --cluster-version "${K8S_VERSION}" \
  --machine-type "n1-standard-1" \
  --image-type "COS" \
  --disk-type "pd-standard" \
  --disk-size "10" \
  --metadata disable-legacy-endpoints=true \
  --scopes "https://www.googleapis.com/auth/devstorage.read_only","https://www.googleapis.com/auth/logging.write","https://www.googleapis.com/auth/monitoring","https://www.googleapis.com/auth/servicecontrol","https://www.googleapis.com/auth/service.management.readonly","https://www.googleapis.com/auth/trace.append","https://www.googleapis.com/auth/ndev.clouddns.readwrite" \
  --preemptible \
  --num-nodes "3" \
  --enable-stackdriver-kubernetes \
  --enable-ip-alias \
  --network "projects/${PROJECT}/global/networks/default" \
  --create-subnetwork name=${NAME} \
  --default-max-pods-per-node "110" \
  --addons HorizontalPodAutoscaling \
  --enable-autoupgrade \
  --enable-autorepair \
  --async

# --scopes "https://www.googleapis.com/auth/ndev.clouddns.readwrite" is required for external-dns
# --subnetwork "projects/${PROJECT}/regions/${PROJECT}/subnetworks/default" \

#!/usr/bin/env bash
set -eux -o pipefail
if [[ -f env.sh ]]; then
  source env.sh
else
  echo cp env.tmpl env.sh and edit values && exit 2
fi

gcloud components install --quiet kubectl beta
gcloud config set project ${PROJECT}
gcloud config set compute/zone ${COMPUTE_ZONE}
gcloud auth configure-docker --quiet
gcloud container clusters get-credentials ${NAME}
#for bash-completion@2 (bash 4.x)
which brew && kubectl completion bash > $(brew --prefix)/share/bash-completion/completions/kubectl
#TODO UNTESTED which pkg-config && kubectl completion bash > $(pkg-config --variable=completionsdir bash-completion)/completions/kubectl
#install helm
which helm || curl https://raw.githubusercontent.com/helm/helm/master/scripts/get | bash

### setup cloudbuild
# add IAM policy for cloudbuild cluster administration
SERVICE_ACCOUNT="$(gcloud projects describe $(gcloud config get-value core/project -q) --format='get(projectNumber)')"
gcloud projects add-iam-policy-binding ${SERVICE_ACCOUNT} \
    --member=serviceAccount:${SERVICE_ACCOUNT}@cloudbuild.gserviceaccount.com \
    --role=roles/container.admin
# and bind the role for creating RBAC roles
kubectl get clusterrolebinding cluster-admin-binding -o jsonpath='{.subjects[*].name}' | grep ${SERVICE_ACCOUNT}@cloudbuild.gserviceaccount.com || \
kubectl create clusterrolebinding cluster-admin-binding \
--clusterrole cluster-admin --user ${SERVICE_ACCOUNT}@cloudbuild.gserviceaccount.com
# here the secrets with configmaps for each release are stored
kubectl get namespace cloudbuild-tiller || kubectl create namespace cloudbuild-tiller

# add IAM policy for cloudbuild kms decryption
#  keyring is named after the project, key is named after the cluster with -cloudbuild appended
#  create keyring:
#     $gcloud kms keyrings create ${PROJECT} --location=global */
#  create key
#     $gcloud kms keys create ${NAME}-cloudbuild \ --location=global \ --keyring=${PROJECT} \ --purpose=encryption

# not used yet - use for secrets
# gcloud kms keys add-iam-policy-binding \
    # ${NAME}-cloudbuild --location=global --keyring=${PROJECT} \
    # --member=serviceAccount:${SERVICE_ACCOUNT}@cloudbuild.gserviceaccount.com \
    # --role=roles/cloudkms.cryptoKeyDecrypter


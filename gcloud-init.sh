#!/usr/bin/env bash
PROJECT=flying-blue-mantis
COMPUTE_ZONE=europe-west1-d
NAME=small-mantis2
gcloud components install --quiet kubectl beta
#gcloud auth login
gcloud config set project ${PROJECT}
gcloud config set compute/zone ${COMPUTE_ZONE}
gcloud auth configure-docker --quiet
gcloud container clusters get-credentials ${NAME}
#bash-completion@2 (bash 4.x)
kubectl completion bash > $(brew --prefix)/share/bash-completion/completions/kubectl

#add policy 
PROJECT="$(gcloud projects describe $(gcloud config get-value core/project -q) --format='get(projectNumber)')"
gcloud projects add-iam-policy-binding ${PROJECT} \
    --member=serviceAccount:${PROJECT}@cloudbuild.gserviceaccount.com \
    --role=roles/container.developer

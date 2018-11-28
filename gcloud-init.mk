#!/usr/bin/env bash
PROJECT=flying-blue-mantis
COMPUTE_ZONE=europe-west1
CLUSTER_NAME=small-mantis-1
gcloud components install --quiet kubectl beta
#gcloud auth login
gcloud config set project ${PROJECT}
gcloud config set compute/zone ${COMPUTE_ZONE}
gcloud auth configure-docker --quiet
gcloud container clusters get-credentials small-mantis-1

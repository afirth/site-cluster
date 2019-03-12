#!/usr/bin/env bash

# @afirth 2019
# encrypts arg1, primarily for embedding into cloudbuild.yaml secrets

set -eu -o pipefail

KEY=cloudbuild

# I name my keyring after the project at this stage
source ../env.sh

echo -n $1 | gcloud kms encrypt \
  --plaintext-file=- \
  --ciphertext-file=- \
  --location=global \
  --keyring=${PROJECT} \
  --key=${KEY} | pbcopy

echo ciphertext copied to clipboard

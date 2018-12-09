#!/usr/bin/env bash
set -eux -o pipefail

gcloud compute firewall-rules create   allow-80-fwr  --allow tcp:80   --network default --source-ranges 0.0.0.0/0
gcloud compute firewall-rules create   allow-443-fwr  --allow tcp:443   --network default --source-ranges 0.0.0.0/0

# site-cluster

## Overview

Installs tooling for a small webserver cluster with reasonable values for small-scale use.

* Avoids using an (expensive) load-balancer by default by running nginx ingress as a daemonset and adding the hostports to an A record
* Supports pre-emptible nodes

## Installs

- external-dns
- ingress-nginx
- cert-manager
  - i'm not convinced this is better thank kube-lego, certainly the dev experience is not at this point. YMMV
- prometheus-operator
- wordpress (+ mariadb)
- nfs (so wordpress runs on multiple nodes)

Runs tillerless helm on cloudbuild

Optimized for cloudbuild and clouddns

## Getting started

```
cp env.tmpl env.sh
chmod +x env.sh
vi env.sh
# and fill in your project details
. gcloud-init.sh
. create-cluster.sh
. create-fw-rules.sh
```

That should complete the cluster setup. Everything else is installing on that cluster.

Create a zone in your DNS provider [see external-dns docs](https://github.com/helm/charts/tree/master/stable/external-dns).

Create a gcloud build for (your fork of) this repository. You'll need to set the subtistute variables in the console at this point (still waiting for the API for _creating_ cloudbuilds) and create a secret keyring, key, and 3 secrets. See `cloudbuild.yaml`.

Note that you need the [helm cloudbuild image](https://github.com/GoogleCloudPlatform/cloud-builders-community/tree/master/helm) available in your project.

## Something not working?
Alternatively, step through the cloudbuild by hand with helm installed locally and configured for tillerless operation (see `hack/helm.sh`). This might be a better choice, as most versions are pinned to latest for my own development.

## Contributing
Please open PRs or issues for anything that breaks - I'm interested in getting this stable and useful without too much feature creep.

# site-cluster

## Overview

Installs tooling for a small webserver cluster with reasonable values for small-scale use.

* Avoids using an (expensive) load-balancer by default by running nginx as a daemonset and adding the hostports to an A record
* Supports pre-emptible nodes

## Installs

- external-dns
- ingress-nginx
- cert-manager

Runs tillerless helm on cloudbuild

Optimized for cloudbuild and clouddns

1. deploy presslabs/mysql-operator https://github.com/presslabs/mysql-operator/tree/master/hack/charts
  1. https://www.presslabs.com/code/kubernetes-mysql-operator-google/
  1. Add secrets
  1. 1x orchestrator with sqlite, 2x mysql, antiaffinity on all, pv on all
    1. add another node pool with 1 node
    1. add label - controllers
    1. add [NodeAffinity In and NotIn to charts](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#node-affinity-beta-feature)
    1. OR 3 orchestrators if they will rejoin successfully when node is killed

1. Configure backups 
  1. https://github.com/presslabs/mysql-operator/blob/master/docs/cluster-recurrent-backups.md
  1. multiple buckets with lifecycle rules
  1. need service account and secret
  
1. Configure wordpress to use DSN from cluster
1. Add secret to chart's cloudbuild
1. Remove mariadb from wordpress deploy
1. Add restore docs: https://github.com/presslabs/mysql-operator/blob/master/docs/cluster-recover.md

1. backup wp folder
  1. mount the nfs volume RO with a backup pod? using kube cron
  1. For now, manual snapshot of NFS backing volume? Future, use volume snapshots when beta/GA (preferred)

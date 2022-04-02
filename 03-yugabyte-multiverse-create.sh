#https://docs.yugabyte.com/latest/yugabyte-platform/install-yugabyte-platform/install-software/kubernetes/

kubectl create ns tanzu-yugabyte-multiverse

helm install tanzu-yugabyte-multiverse \
      yugabytedb/yugabyte  \
      --version=2.11.2 \
      --set resource.master.requests.cpu=0.5 \
      --set resource.master.requests.memory=0.5Gi \
      --set resource.tserver.requests.cpu=0.5 \
      --set resource.tserver.requests.memory=0.5Gi \
      --set replicas.master=3 \
      --set replicas.tserver=4 \
      --set enableLoadBalancer=True \
      --set storage.master.storageClass=yugabyte-data \
      --set storage.master.size=5Gi \
      --set storage.tserver.storageClass=yugabyte-data \
      --set storage.tserver.size=10Gi \
      --namespace tanzu-yugabyte-multiverse

#TO CHANGE CLUSTER PROPERTIES...
#helm uprade --set ~~~~~

#SCALE CLUSTER SIZE
#helm upgrade --set replicas.tserver=5 ./yugabyte

or

#kubectl scale statefulset yb-tserver --replicas=5
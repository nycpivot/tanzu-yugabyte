#https://docs.yugabyte.com/latest/yugabyte-platform/install-yugabyte-platform/install-software/kubernetes/

kubectl create ns yb-demo

helm template yb-demo \
      yugabytedb/yugabyte  \
      --version=2.11.2 \
      --set resource.master.requests.cpu=0.5 \
      --set resource.master.requests.memory=0.5Gi \
      --set resource.tserver.requests.cpu=0.5 \
      --set resource.tserver.requests.memory=0.5Gi \
      --set replicas.master=3 \
      --set replicas.tserver=3 \
      --set enableLoadBalancer=True \
      --set storage.master.storageClass=yugabyte-data \
      --set storage.master.size=5Gi \
      --set storage.tserver.storageClass=yugabyte-data \
      --set storage.tserver.size=10Gi \
      --namespace yb-demo > yb-multiverse.yaml

kubectl apply -n yb-demo -f yb-multiverse.yaml

#helm uprade --set ~~~~~

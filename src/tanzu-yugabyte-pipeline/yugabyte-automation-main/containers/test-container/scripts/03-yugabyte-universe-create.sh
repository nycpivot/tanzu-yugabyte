#!bin/bash

#https://docs.yugabyte.com/latest/yugabyte-platform/install-yugabyte-platform/install-software/kubernetes/

[[ -z "$TANZU_YB_SECRET" ]] && { echo "TANZU_YB_SECRET is empty. Please set" ; exit 1; }
[[ -z "$TANZU_CLUSTER_NAME" ]] && { echo "TANZU_CLUSTER_NAME is empty. Please set" ; exit 1; }
[[ -z "$TANZU_YB_MASTER_COUNT" ]] && { echo "TANZU_YB_MASTER_COUNT is empty. Please set" ; exit 1; }
[[ -z "$TANZU_YB_TSERVER_COUNT" ]] && { echo "TANZU_YB_TSERVER_COUNT is empty. Please set" ; exit 1; }
[[ -z "$TANZU_YB_VERSION" ]] && { echo "TANZU_YB_VERSION is empty. Please set" ; exit 1; }


yugabyte_secret=$TANZU_YB_SECRET
cluster_name=$TANZU_CLUSTER_NAME
master_count=$TANZU_YB_MASTER_COUNT
tserver_count=$TANZU_YB_TSERVER_COUNT
yugabyte_version=$TANZU_YB_VERSION

export KUBECONFIG=wl-kubeconfig

kubectl config use-context ${cluster_name}-admin${cluster_name}

kubectl create ns $cluster_name

#APPLY STORAGE CLASS AND PV
kubectl delete -f /tmp/yb-storage.yaml
kubectl apply -f /tmp/yb-storage.yaml -n $cluster_name

rm ${cluster_name}.yaml

helm repo add yugabytedb https://charts.yugabyte.com --insecure-skip-tls-verify 
helm repo update


helm template $cluster_name \
      yugabytedb/yugabyte  \
      --version=$yugabyte_version \
      --set resource.master.requests.cpu=0.5 \
      --set resource.master.requests.memory=0.5Gi \
      --set resource.tserver.requests.cpu=0.5 \
      --set resource.tserver.requests.memory=0.5Gi \
      --set replicas.master=$master_count \
      --set replicas.tserver=$tserver_count \
      --set enableLoadBalancer=True \
      --set storage.master.storageClass=yugabyte-data \
      --set storage.master.size=5Gi \
      --set storage.tserver.storageClass=yugabyte-data \
      --set storage.tserver.size=10Gi \
      --namespace $cluster_name --insecure-skip-tls-verify  > ${cluster_name}.yaml
			
kubectl apply -f ${cluster_name}.yaml -n $cluster_name

#bash tanzu-yugabyte/31-demo-post-universe-install.sh $cluster_name


#TO CHANGE CLUSTER PROPERTIES...
#helm uprade --set replicas.tserver=5

#SCALE CLUSTER SIZE
#helm upgrade --set replicas.tserver=5 ./yugabyte

#or

#kubectl scale statefulset yb-tserver --replicas=5

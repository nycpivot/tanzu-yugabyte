#!bin/bash


#https://docs.yugabyte.com/latest/yugabyte-platform/install-yugabyte-platform/install-software/kubernetes/

#read -p "Azure subscription: " subscription
#read -p "Cluster name: " cluster_name

yugabyte_secret=$TANZU_YB_SECRET
cluster_name=$TANZU_CLUSTER_NAME

export KUBECONFIG=wl-kubeconfig


kubectl config use-context ${cluster_name}-admin@${cluster_name}

kubectl create namespace yb-platform

kubectl get nodes

rm tanzu-yugabyte/yugabyte-k8s-secret.yaml
cat <<EOF > yugabyte-k8s-secret.yaml
apiVersion: v1
kind: Secret
metadata:
  name: yugabyte-k8s-pull-secret
data:
  .dockerconfigjson: $yugabyte_secret
type: kubernetes.io/dockerconfigjson
EOF

kubectl apply -f yugabyte-k8s-secret.yaml -n yb-platform

helm repo add yugabytedb https://charts.yugabyte.com --insecure-skip-tls-verify 
helm repo update
helm search repo yugabytedb/yugaware -l
echo "Downloading chart"
helm pull https://charts.yugabyte.com yugabytedb/yugaware --insecure-skip-tls-verify 
echo "Installing chart"
helm install yugabyte-platform yugabytedb/yugaware -n yb-platform --insecure-skip-tls-verify  --wait #-v 6

kubectl get pods -n yb-platform
kubectl get svc -n yb-platform
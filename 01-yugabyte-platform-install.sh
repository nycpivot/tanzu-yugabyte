#https://docs.yugabyte.com/latest/yugabyte-platform/install-yugabyte-platform/install-software/kubernetes/

read -p "Azure subscription: " subscription
read -p "Cluster context: " cluster_context

yugabyte_secret=$(az keyvault secret show --name yugabyte-secret --subscription $subscription --vault-name tanzuvault --query value --output tsv)

kubectl config use-context ${cluster_context}-admin@${cluster_context}

kubectl create namespace yb-platform

mkdir tanzu-yugabyte

rm tanzu-yugabyte/yugabyte-k8s-secret.yaml
cat <<EOF | tee tanzu-yugabyte/yugabyte-k8s-secret.yaml
apiVersion: v1
kind: Secret
metadata:
  name: yugabyte-k8s-pull-secret
data:
  .dockerconfigjson: $yugabyte_secret
type: kubernetes.io/dockerconfigjson
EOF

kubectl apply -f tanzu-yugabyte/yugabyte-k8s-secret.yaml -n yb-platform

helm repo add yugabytedb https://charts.yugabyte.com
helm repo update
#helm search repo yugabytedb/yugaware -l | grep 2.13.0
helm install yugabyte-platform yugabytedb/yugaware --version 2.13.0 -n yb-platform --wait


#APPLY STORAGE CLASS AND PV
kubectl apply -f tanzu-yugabyte/yb-storage.yaml

kubectl get pods -n yb-platform
kubectl get svc -n yb-platform

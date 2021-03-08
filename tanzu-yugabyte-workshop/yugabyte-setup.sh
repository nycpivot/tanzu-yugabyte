wget https://tanzustorage.blob.core.windows.net/yugabyte/yugabyte-rbac.yaml
wget https://tanzustorage.blob.core.windows.net/yugabyte/storage-class.yaml
wget https://tanzustorage.blob.core.windows.net/yugabyte/generate-kubeconfig.py
wget https://tanzustorage.blob.core.windows.net/yugabyte/yugabyte-k8s-secret.yaml

sudo kubectl apply -f yugabyte-rbac.yaml
sudo kubectl apply -f storage-class.yaml

python generate-kubeconfig.py -s yugabyte-helm

sudo kubectl create namespace yb-platform

sudo kubectl create -f yugabyte-k8s-secret.yml -n yb-platform

sudo helm repo add yugabytedb https://charts.yugabyte.com
sudo helm search repo yugabytedb/yugaware -l
sudo helm install yw-test yugabytedb/yugaware --version 2.2.6 -n yb-platform --wait

sudo kubectl get svc -n yb-platform


sudo kubectl apply -f yugabyte-setup/yugabyte-rbac.yaml
sudo kubectl apply -f yugabyte-setup/storage-class.yaml

sudo python yugabyte-setup/generate-kubeconfig.py -s yugabyte-helm

sudo kubectl create namespace yb-platform

sudo kubectl create -f yugabyte-setup/yugabyte-k8s-secret.yaml -n yb-platform

sudo helm repo add yugabytedb https://charts.yugabyte.com
sudo helm search repo yugabytedb/yugaware -l
sudo helm install yw-test yugabytedb/yugaware --version 2.2.6 -n yb-platform --wait

sudo kubectl get svc -n yb-platform


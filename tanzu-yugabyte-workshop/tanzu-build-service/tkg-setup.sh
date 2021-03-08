read -p "AWS Config (aws-ap-south-one): " aws_config_name
read -p "Worker Count: " worker_machine_count

sudo tkg create cluster --name tanzu-yugabyte-${aws_config_name} --plan dev --worker-machine-count ${worker-machine-count} --config .tkg/${aws_config_name}.yaml
sudo tkg get credentials tanzu-yugabyte-${aws_config_name} --config .tkg/${aws_config_name}

sudo kubectl config use-context tanzu-yugabyte-${aws_config_name}-admin@tanzu-yugabyte-${aws_config_name}

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


#https://docs.yugabyte.com/latest/yugabyte-platform/install-yugabyte-platform/install-software/kubernetes/

read -p "Cluster name: " cluster_name
read -p "Master count: " master_count #3
read -p "TServer count: " tserver_count #3 or more

kubectl config use-contex${cluster_name}-admin${cluster_name}

kubectl create ns $cluster_name

#APPLY STORAGE CLASS AND PV
kubectl delete -f tanzu-yugabyte/yb-storage.yaml
kubectl apply -f tanzu-yugabyte/yb-storage.yaml -n $cluster_name

rm ${cluster_name}.yaml
helm template $cluster_name \
      yugabytedb/yugabyte  \
      --version=2.11.2 \
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
      --namespace $cluster_name > ${cluster_name}.yaml
			
kubectl apply -f ${cluster_name}.yaml -n $cluster_name

#bash tanzu-yugabyte/31-demo-post-universe-install.sh $cluster_name


#TO CHANGE CLUSTER PROPERTIES...
#helm uprade --set replicas.tserver=5

#SCALE CLUSTER SIZE
#helm upgrade --set replicas.tserver=5 ./yugabyte

#or

#kubectl scale statefulset yb-tserver --replicas=5

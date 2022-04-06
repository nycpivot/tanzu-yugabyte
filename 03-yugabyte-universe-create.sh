#https://docs.yugabyte.com/latest/yugabyte-platform/install-yugabyte-platform/install-software/kubernetes/

read -p "Universe name: " universe_name
read -p "Master count: " master_count #3
read -p "TServer count: " tserver_count #3 or more

kubectl create ns $universe_name

#APPLY STORAGE CLASS AND PV
kubectl delete -f tanzu-yugabyte/yb-storage.yaml
kubectl apply -f tanzu-yugabyte/yb-storage.yaml -n $universe_name

rm ${universe_name}.yaml
helm template $universe_name \
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
      --namespace $universe_name > ${universe_name}.yaml
			
kubectl apply -f ${universe_name}.yaml -n $universe_name

#bash tanzu-yugabyte/31-demo-post-universe-install.sh $universe_name


#TO CHANGE CLUSTER PROPERTIES...
#helm uprade --set replicas.tserver=5

#SCALE CLUSTER SIZE
#helm upgrade --set replicas.tserver=5 ./yugabyte

#or

#kubectl scale statefulset yb-tserver --replicas=5

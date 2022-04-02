read -p "Workload Cluster Name: " workload_cluster_name

kubectl config use-context ${workload_cluster_name}-admin@${workload_cluster_name}

kubectl get pods -n $workload_cluster_name -o wide

aws ec2 describe-instances | jq -r '.Reservations[].Instances[]|.InstanceId+"\t"+.Placement.AvailabilityZone+"\t"+.PrivateIpAddress+"\t"+(.Tags[] | select(.Key == "Name").Value)+"\t"+.State.Name' | grep multi-az-md

read -p "Instance Id: " instance_id

aws ec2 stop-instances --instance-ids $instance_id



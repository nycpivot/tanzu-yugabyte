#!/bin/bash

########################
# include the magic
########################
. demo-magic.sh

########################
# Configure the options
########################

#
# speed at which to simulate typing. bigger num = faster
#
TYPE_SPEED=15

#
# custom prompt
#
# see http://www.tldp.org/HOWTO/Bash-Prompt-HOWTO/bash-prompt-escape-sequences.html for escape sequences
#
#DEMO_PROMPT="${GREEN}➜ ${CYAN}\W "

# hide the evidence
clear

DEMO_PROMPT="${GREEN}➜ YB ${CYAN}\W "

read -p "Universe name: " universe_name

pe "kubectl get ns"
echo

pe "kubectl get pods -n ${universe_name}"
echo

pe "kubectl exec -it yb-tserver-0 -n ${universe_name} -- df -kh"
echo

pe "kubectl get svc -n ${universe_name}"
echo






#kubectl get pods -n $workload_cluster_name -o wide

#aws ec2 describe-instances | jq -r '.Reservations[].Instances[]|.InstanceId+"\t"+.Placement.AvailabilityZone+"\t"+.PrivateIpAddress+"\t"+(.Tags[] | select(.Key == "Name").Value)+"\t"+.State.Name' | grep multiverse-md

#read -p "Instance Id: " instance_id

#aws ec2 stop-instances --instance-ids $instance_id



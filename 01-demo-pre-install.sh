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

read -p "Workload Cluster Name (tanzu-yugabyte-multiverse): " workload_cluster_name
echo

if [ -z $workload_cluster_name ]
then
	workload_cluster_name=tanzu-yugabyte-multiverse
fi

pe "kubectl config use-context ${workload_cluster_name}-admin@${workload_cluster_name}"
echo

pe "kubectl get ns"
echo

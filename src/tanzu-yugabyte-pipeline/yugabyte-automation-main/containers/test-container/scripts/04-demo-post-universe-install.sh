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

pe "kubectl get ns"
echo

pe "kubectl get pods -n tanzu-yb-multiverse --watch"
echo

pe "kubectl exec -it yb-tserver-0 -n tanzu-yb-multiverse -- df -kh"
echo

pe "kubectl get svc -n tanzu-yb-multiverse | grep yb-master-ui"
echo

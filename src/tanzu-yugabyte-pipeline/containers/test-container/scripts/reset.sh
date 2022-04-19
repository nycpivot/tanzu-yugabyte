[[ -z "$TANZU_CLUSTER_NAME" ]] && { echo "TANZU_CLUSTER_NAME is empty. Please set" ; exit 1; }

kubectl delete ns $TANZU_CLUSTER_NAME
kubectl delete ns yb-platform

kubectl delete -f tanzu-yugabyte/yb-storage.yaml

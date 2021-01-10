rm .tkg/config.yaml
tkg get management-cluster

echo AZURE_TENANT_ID: $tenantId >> .tkg/config.yaml
echo AZURE_SUBSCRIPTION_ID: $subscriptionId >> .tkg/config.yaml
echo AZURE_LOCATION: eastus >> .tkg/config.yaml
echo AZURE_RESOURCE_GROUP: tanzu-azure >> .tkg/config.yaml
echo AZURE_NODE_MACHINE_TYPE: Standard_D2s_v3 >> .tkg/config.yaml
echo MACHINE_HEALTH_CHECK_ENABLED: "true" >> .tkg/config.yaml
echo AZURE_CONTROL_PLANE_MACHINE_TYPE: Standard_D2s_v3 >> .tkg/config.yaml
echo AZURE_CLIENT_ID: c77e1088-ae89-4d41-9d51-b2bfc3e27cc7 >> .tkg/config.yaml
echo AZURE_CLIENT_SECRET: $clientKey >> .tkg/config.yaml
echo AZURE_SSH_PUBLIC_KEY_B64: c3NoLXJzYSBBQUFBQjNOemFDMXljMkVBQUFBREFRQUJBQUFDQVFDeC84NHRpaVZWeXNpUEdoM0RWbjhETmRHWVU3QkE1MmR0MFdTUzdWbTlhNmQzaDdHaHZmQXpZLzBiamRMK21Md25nZlJIbFhLTnBMeUVuWmdEL3dhd0FoZEpNcW1ROFI2aEpJYjViK2xGTTZrZld5TDNNcGREeGg4MWN4L01JUksxamwyd0Vuc0dSUy9PUWo5RE0ya0h3ZkVocC9IRVVDZEJ6a3ZyQkxEY3hRbGxyQjBhRXRyd3Y5RDRydG5FcmV6OFlnaWtyU1RVWGZuRmY5dGVEMVgvMXRSMktyTjlsQlFRYm1lTHIwd2RZRGdZQWhORTJHajNLT1VtdXFDK3Y5Ukc5L2ZJU3paM0VYL2R0bWJwbWNSWk12L1NtV081MkdTL2N0YnhYME1BQ2lHeldVNmk5OVRETTVsdmZpM3k1dUpmV0t2SnVxSExCd1FYU3JrdDVhdldBU1BCQnZ0SU93YVo1Qno2STQvVEZJcEcxTmo2YmlzU0dnNSt5R3F3TncyclF4cEhnYS96R3ZEVDluK010Uko5cEdUV0ErMmc5aUhTako5QW9LV3c5d1hONHpQSnFzNEZ0M2N6bDg3VVBYMk11QXpLOWM4SC9MdjdaZDRWcHdSd3FlMkJ5bm9BUmlRQlcxMUpBNWliSWlCaFBqTEY1c3NtWVIraUF1NTFCb3NJc2I5YkdZbGF6cEtsbk5uYmhOaWNkem1TdVNEOTh0SjlXR3NudTNlRk9ka1Z0QVNJSEExbXhJMjB3Q0hLY2tDWm9hSHpZUnVBOWtPREsyY3gzZ0pHYVZBalQ3Y1VaOU1sMnQ0ZmdYODRtdTdhaTV1enF1UnpZdittZGpRZm9wdDh3M2NxWUhmWUtzMENHQVNNdlp5SjRZcGlzUXlUTG9KaVBVbmJQUmFSN3c9PQ==  >> .tkg/config.yaml
echo SERVICE_CIDR: 100.64.0.0/13 >> .tkg/config.yaml
echo CLUSTER_CIDR: 100.96.0.0/11 >> .tkg/config.yaml
echo AZURE_VNET_NAME: tkg-management-cluster-vnet >> .tkg/config.yaml
#export AZURE_VNET_CIDR: 10.10.0.0/16
#export AZURE_CONTROL_PLANE_SUBNET_NAME: default
#export AZURE_CONTROL_PLANE_SUBNET_CIDR: 10.10.0.0/24
#export AZURE_NODE_SUBNET_NAME: default
#export AZURE_NODE_SUBNET_CIDR: 10.10.0.0/24

sudo tkg init --name tkg-management-cluster --infrastructure azure --plan dev

kubectl logs deployment.apps/capz-controller-manager -n capz-system manager --kubeconfig ~/.kube-tkg/tmp/

wget https://tanzustorage.blob.core.windows.net/tkg/velero-v1.5.2-linux-amd64.tar.gz
gzip -d velero-v1.5.2-linux-amd64.tar.gz
tar -xvf velero-v1.5.2-linux-amd64.tar

sudo mv velero-v1.5.2-linux-amd64/velero /usr/local/bin/velero
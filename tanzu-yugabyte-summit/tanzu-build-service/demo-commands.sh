read -p "ACR Registry Name: " registry

kp image create tbs-core-web-mvc \
	--tag ${registry}.azurecr.io/tbs-core-web-mvc \
	--git https://github.com/nycpivot/tanzu-build-service

kp image status tbs-core-web-mvc
kp build logs tbs-core-web-mvc

read -p "ACR Server: " acrserver
read -p "ACR Username: " acruser
read -p "ACR Password: " acrpassword

kubectl create secret docker-registry tbsyugabyte-secret \
	--docker-server=${acrserver} \
	--docker-username=${acruser} \
	--docker-password=${acrpassword} \
	--docker-email=mijames@vmware.com


kubectl apply -f aks-deployment.yaml

kubectl set image deployment tbs-deployment tbs-core-web-mvc=${acrserver}/tbs-core-web-mvc:latest

kp image create tanzu-yugabyte-image \
	--tag harbor.tanzulab.com/tanzu-yugabyte/tanzu-yugabyte-image \
	--git https://github.com/yugabyte/spring-tanzu-workshop --sub-path product-catalog-microservice
	
	
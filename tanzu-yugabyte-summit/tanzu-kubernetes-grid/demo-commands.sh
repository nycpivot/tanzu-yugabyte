sudo tkg create cluster tkg-cluster --plan dev
tkg get credentials tkg-cluster

kubectl config use-context tkg-cluster-admin@tkg-cluster

kubectl create secret docker-registry tanzuregistry-secret \
	--docker-server=tanzuregistry.azurecr.io \
	--docker-username=tanzuregistry \
	--docker-password=${acrkey} \
	--docker-email=mijames@vmware.com
	
kubectl apply -f tkg-deployment.yaml



apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: default-deny-ingress
  namespace: backend
spec:
  podSelector: {}
  policyTypes:
  - Ingress


apiVersion: v1
kind: Pod
metadata:
  name: nginx
spec:
  volumes:
  - name: sec-ctx-vol
    emptyDir: {}
  containers:
  - name: nginx
    image: nginx
    volumeMounts:
    - name: sec-ctx-vol
      mountPath: /data/demo
    securityContext:
      allowPrivilegeEscalation: false
    resources:
      requests:
        memory: "3Gi"
		
		
		Freddie Mac
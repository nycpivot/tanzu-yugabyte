read -p "Harbor Server: " harborserver
read -p "Harbor Project (tanzu-yugabyte-conference): " harborproject
read -p "Harbor Username: " harborusername
read -p "Harbor Password: " harborpassword

kubectl config use-context tanzu-build-service-admin@tanzu-build-service

read -p "Pivotal Username: " pivotuser
read -p "Pivotal Password: " pivotpass
read -p "Harbor Repository Name (tbsimages): " repository

sudo docker login registry.pivotal.io -u $pivotuser -p $pivotpass
sudo docker login $harborserver -u $harborusername -p $harborpassword

sudo kbld relocate -f /tmp/images.lock \
		--lock-output /tmp/images-relocated.lock \
		--repository ${harborserver}/${harborproject}/images

ytt -f /tmp/values.yaml \
    -f /tmp/manifests/ \
    -v docker_repository=${harborserver}/${harborproject}/images \
    -v docker_username=$harborusername \
    -v docker_password=$harborpassword \
    | sudo kbld -f /tmp/images-relocated.lock -f- \
    | kapp deploy -a $harborproject -f- -y

sudo kp import -f descriptor.yaml

kp clusterbuilder list

kp secret create tanzuregistry-secret --registry $harborserver --registry-user $harborusername

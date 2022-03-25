read -p "Azure subscription: " subscription

sudo apt update
yes | sudo apt upgrade

#DOCKER
yes | sudo apt install docker.io
sudo systemctl enable docker
sudo systemctl start docker

sudo usermod -aG docker $USER


#MISC TOOLS
sudo snap install jq
sudo snap install helm --classic
sudo apt install unzip

yes | sudo apt install python2-minimal

#yes | sudo apt install python3-pip
#pip3 install yq


#AWS CLI
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
rm awscliv2.zip

#AZURE
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
az login
az account set --subscription $subscription


#KUBECTL
wget https://tanzustorage.blob.core.windows.net/tanzu/kubectl-linux-v1.22.5+vmware.1.gz
gunzip kubectl-linux-v1.22.5+vmware.1.gz

sudo install kubectl-linux-v1.22.5+vmware.1 /usr/local/bin/kubectl
rm kubectl-linux-v1.22.5+vmware.1
kubectl version


#DEMO-MAGIC
wget https://raw.githubusercontent.com/paxtonhare/demo-magic/master/demo-magic.sh
sudo mv demo-magic.sh /usr/local/bin/demo-magic.sh
chmod +x /usr/local/bin/demo-magic.sh

sudo apt install pv #required for demo-magic

rm operator-bootstrapper.sh

echo
echo "***REBOOTING***"
echo

sudo reboot

echo 'debconf debconf/frontend select Noninteractive' | sudo debconf-set-selections

#Update
sudo apt-get update

sudo apt-get install cloud-guest-utils

#see https://github.com/moby/moby/issues/27988
sudo apt-get install dialog apt-utils -y

#https://www.bggofurther.com/2019/07/add-timestamp-on-each-line-of-bash-output/
sudo apt-get install moreutils

#Install prereqs
# see https://phoenixnap.com/kb/add-apt-repository-command-not-found-ubuntu
sudo apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \
    software-properties-common

sudo apt-get install -y \
    net-tools \
    tree \
    jq \
    git

jq --version

#Install Snap
sudo apt-get install -y snapd

#Install Go
#see https://wpcademy.com/how-to-install-go-on-ubuntu-18-04-lts/
sudo snap install go --classic
echo 'export GOPATH=$HOME/go' >> ~/.bashrc 
echo 'export PATH=${PATH}:${GOPATH}/bin' >> ~/.bashrc 
go version

#Install govc
# see: https://github.com/vmware/govmomi/tree/master/govc
# extract govc binary to /usr/local/bin
# note: the "tar" command must run with root permissions
curl -s -L -o - "https://github.com/vmware/govmomi/releases/latest/download/govc_$(uname -s)_$(uname -m).tar.gz" | sudo tar -C /usr/local/bin -xvzf - govc
govc version

#Install kubectl
curl -s -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo chmod a+x kubectl 
sudo mv kubectl /usr/local/bin
kubectl

#Install helm
sudo snap install helm --classic

#Install Carvel Tools
#see: https://github.com/vmware-tanzu/carvel/issues/129
sudo apt-get install -y libdigest-sha-perl
wget -O- https://carvel.dev/install.sh | sudo bash

ytt --version
kapp --version


#Install Packer & Terraform
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install -y packer terraform

packer
terraform

#Install kind
curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.11.1/kind-linux-amd64
chmod +x ./kind
sudo mv ./kind /usr/local/bin

kind version



#https://linuxize.com/post/how-to-install-node-js-on-ubuntu-20-04/
#installing node
curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -
sudo apt-get update && sudo apt-get install -y nodejs
node --version
npm --version


#install tmux
sudo apt-get install -y tmux


#install dog
#https://github.com/ogham/dog
sudo snap install dog


wget --quiet https://github.com/rs/curlie/releases/download/v1.6.7/curlie_1.6.7_linux_amd64.deb
sudo dpkg -i curlie_1.6.7_linux_amd64.deb 



#install gtop
#https://github.com/aksakalli/gtop
sudo npm install gtop -g


#install bottom
sudo snap install bottom


#install ag
#https://github.com/ggreer/the_silver_searcher
sudo apt-get install silversearcher-ag


#install stern
wget --quiet https://github.com/stern/stern/releases/download/v1.21.0/stern_1.21.0_linux_amd64.tar.gz
tar xzvf stern_1.21.0_linux_amd64.tar.gz 
sudo install stern /usr/local/bin/stern
stern -v

exit 0
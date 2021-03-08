wget https://raw.githubusercontent.com/nycpivot/tanzu-yugabyte/main/tanzu-yugabyte-workshop/tanzu-kubernetes-grid/tkg-setup.sh
wget https://raw.githubusercontent.com/nycpivot/tanzu-yugabyte/main/tanzu-yugabyte-workshop/yugabyte-setup.sh

mkdir yugabyte-setup

mv tkg-setup.sh yugabyte-setup/tkg-setup.sh
mv yugabyte-setup.sh yugabyte-setup/yugabyte-setup.sh

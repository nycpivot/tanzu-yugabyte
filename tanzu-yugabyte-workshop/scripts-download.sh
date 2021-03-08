wget https://raw.githubusercontent.com/nycpivot/tanzu-yugabyte/main/tanzu-yugabyte-workshop/tanzu-kubernetes-grid/tkg-setup.sh
wget https://raw.githubusercontent.com/nycpivot/tanzu-yugabyte/main/tanzu-yugabyte-workshop/yugabyte-setup.sh

mkdir scripts

mv tkg-setup.sh scripts/tkg-setup.sh
mv yugabyte-setup.sh scripts/yugabyte-setup.sh

sudo apt-get install wget

rm yugabyte-2.13.0.1-b2-linux-x86_64.tar.gz
rm -rf yugabyte-2.13.0.1


#GET YUGABYTE PACKAGES
wget https://downloads.yugabyte.com/releases/2.13.0.1/yugabyte-2.13.0.1-b2-linux-x86_64.tar.gz
tar xvfz yugabyte-2.13.0.1-b2-linux-x86_64.tar.gz
cd yugabyte-2.13.0.1/

./bin/post_install.sh
#./bin/yugabyted start

cd $HOME
#Move launch script
sudo mv /tmp/launch.sh /root 

sudo apt-get update
sudo apt-get install -y gnupg
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 3EFE0E0A2F2F60AA
echo "deb http://ppa.launchpad.net/tektoncd/cli/ubuntu focal main"|sudo tee /etc/apt/sources.list.d/tektoncd-ubuntu-cli.list
sudo apt-get update -y && sudo apt-get install -y tektoncd-cli

#
sudo apt-get install shellcheck
sudo apt-get install shunit2

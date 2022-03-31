#INSTALL JAVA
wget https://download.java.net/java/GA/jdk17/0d483333a00540d886896bac774ff48b/35/GPL/openjdk-17_linux-x64_bin.tar.gz
gzip -d openjdk-17_linux-x64_bin.tar.gz
tar -xvf openjdk-17_linux-x64_bin.tar

sudo mkdir /opt/java
sudo mv jdk-17 /opt/java/jdk-17
rm openjdk-17_linux-x64_bin.tar

export JAVA_HOME=/opt/java/jdk-17
export PATH=$PATH:/opt/java/jdk-17/bin
export PATH=$PATH:/opt/maven/apache-maven-3.8.5/bin


#INSTALL MAVEN
wget https://dlcdn.apache.org/maven/maven-3/3.8.5/binaries/apache-maven-3.8.5-bin.tar.gz
gzip -d apache-maven-3.8.5-bin.tar.gz
tar -xvf apache-maven-3.8.5-bin.tar

sudo mkdir /opt/maven
sudo mv apache-maven-3.8.5 /opt/maven
rm apache-maven-3.8.5-bin.tar


#GET YUGABYTE PACKAGES
wget https://downloads.yugabyte.com/releases/2.13.0.1/yugabyte-2.13.0.1-b2-linux-x86_64.tar.gz
tar xvfz yugabyte-2.13.0.1-b2-linux-x86_64.tar.gz
cd yugabyte-2.13.0.1/

./bin/post_install.sh
#./bin/yugabyted start


#GET APP REPO (YUGASTORE)
rm yugastore-java

git clone https://github.com/yugabyte/yugastore-java

cd yugastore-java

mvn -DskipTests package

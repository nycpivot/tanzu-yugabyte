#INSTALL JAVA
wget https://download.java.net/java/GA/jdk17/0d483333a00540d886896bac774ff48b/35/GPL/openjdk-17_linux-x64_bin.tar.gz
gzip -d openjdk-17_linux-x64_bin.tar.gz
tar -xvf openjdk-17_linux-x64_bin.tar

sudo mkdir /usr/lib/java
sudo mv jdk-17 /usr/lib/java/jdk-17
rm openjdk-17_linux-x64_bin.tar

export PATH=$PATH:/usr/lib/java/jdk-17/bin
export JAVA_HOME=/usr/lib/java/jdk-17

#INSTALL MAVEN
wget https://dlcdn.apache.org/maven/maven-3/3.8.5/binaries/apache-maven-3.8.5-bin.tar.gz
gzip -d apache-maven-3.8.5-bin.tar.gz
tar -xvf apache-maven-3.8.5-bin.tar

sudo mkdir /usr/lib/maven
sudo mv apache-maven-3.8.5 /usr/lib/maven
rm apache-maven-3.8.5-bin.tar

export PATH=$PATH:/usr/lib/maven/apache-maven-3.8.5/bin

#https://docs.yugabyte.com/latest/yugabyte-platform/install-yugabyte-platform/install-software/kubernetes/

git clone https://github.com/yugabyte/spring-tanzu-workshop.git


#BUILD DATABASE
wget https://downloads.yugabyte.com/yugabyte-2.2.6.0-linux.tar.gz
gzip -d yugabyte-2.2.6.0-linux.tar.gz
tar -xvf yugabyte-2.2.6.0-linux.tar

yugabyte-2.2.6.0/bin/ycqlsh -f spring-tanzu-workshop/database-setup/schema.cql

kubectl get svc -n yb-platform

read -p "Input External IP: " external_ip

export CQLSH_HOST=$external_ip
export CQLSH_PORT=9042

sh spring-tanzu-workshop/database-setup/dataload.sh


#BUILD DOCKER IMAGE



export JAVA_HOME=/usr/opt/java/jdk-17
export PATH=$PATH:/usr/opt/java/jdk-17/bin
export PATH=$PATH:/usr/opt/maven/apache-maven-3.8.4/bin
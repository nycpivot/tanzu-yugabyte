#https://docs.yugabyte.com/latest/yugabyte-platform/install-yugabyte-platform/install-software/kubernetes/

rm spring-tanzu-workshop
git clone https://github.com/yugabyte/spring-tanzu-workshop.git


#BUILD DATABASE
wget https://downloads.yugabyte.com/releases/2.11.2.0/yugabyte-2.11.2.0-b89-linux-x86_64.tar.gz # https://downloads.yugabyte.com/yugabyte-2.2.6.0-linux.tar.gz
gzip -d yugabyte-2.11.2.0-b89-linux-x86_64.tar.gz # yugabyte-2.2.6.0-linux.tar.gz
tar -xvf yugabyte-2.11.2.0-b89-linux-x86_64.tar # yugabyte-2.2.6.0-linux.tar

kubectl get svc -A

read -p "Input External IP: " external_ip

export CQLSH_HOST=$external_ip
export CQLSH_PORT=9042

yugabyte-2.11.2.0/bin/ycqlsh -f spring-tanzu-workshop/database-setup/schema.cql
#yugabyte-2.2.6.0/bin/ycqlsh -f spring-tanzu-workshop/database-setup/schema.cql

cd spring-tanzu-workshop/database-setup
sudo sh dataload.sh
echo

cd $HOME

#BUILD AND RUN APP
export JAVA_HOME=/usr/lib/java/jdk-17
export PATH=$PATH:/usr/lib/java/jdk-17/bin
export PATH=$PATH:/usr/lib/maven/apache-maven-3.8.4/bin

cd spring-tanzu-workshop/product-catalog-microservice

mvn -DskipTests clean package
mvn spring-boot:run

echo http://localhost:8082/swagger-ui/index.html#/







kubectl exec -it -n yb-dev-tanzu-yugabyte-universe yb-tserver-2 -- ycqlsh -f schema.cql
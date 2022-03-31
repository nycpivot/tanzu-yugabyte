#https://docs.yugabyte.com/latest/yugabyte-platform/install-yugabyte-platform/install-software/kubernetes/

rm spring-tanzu-workshop
git clone https://github.com/yugabyte/spring-tanzu-workshop.git




kubectl get svc -A | grep tserver

read -p "Input External IP: " external_ip

export CQLSH_HOST=$external_ip
export CQLSH_PORT=9042


#BUILD DATABASE SCHEMA
./yugabyte-2.13.0.1/bin/cqlsh -f $HOME/yugastore-java/resources/schema.cql


#LOAD DATA
cd $HOME/yugastore-java/resources

rm dataload.sh
cat <<EOF | tee dataload.sh
for i in products.json;
do
  python parse_metadata_json.py $i;
  ./cassandra-loader -f cronos_products.csv -host $external_ip -schema "cronos.products(asin, title, description, price, imUrl, also_bought, also_viewed, bought_together, buy_after_viewing, brand, categories,num_reviews,num_stars,avg_stars)" -maxInsertErrors 10000 -maxErrors 10000 -charsPerColumn 256000;
  ./cassandra-loader -f cronos_product_rankings.csv -host $external_ip -schema "cronos.product_rankings(asin, category, sales_rank, title, price, imurl, num_reviews, num_stars, avg_stars)" -maxInsertErrors 10000 -maxErrors 10000 -charsPerColumn 256000;
  ./cassandra-loader -f cronos_product_inventory.csv -host $external_ip -schema "cronos.product_inventory(asin, quantity)";
  rm *.csv*
done
EOF

./dataload.sh


#START EUREKA
cd $HOME/yugastore-java/eureka-server-local
mvn spring-boot:run


#API SERVICE
cd $HOME/yugastore-java/api-gateway-microservice
mvn spring-boot:run

#PRODUCTS
cd $HOME/yugastore-java/products-microservice
mvn spring-boot:run

#CHECKOUT
cd $HOME/yugastore-java/checkout-microservice
mvn spring-boot:run

#CART
cd $HOME/yugastore-java/cart-microservice
mvn spring-boot:run

#WEB UI
cd $HOME/yugastore-java/react-ui
mvn spring-boot:run







cd spring-tanzu-workshop/database-setup
sudo sh dataload.sh
echo

cd $HOME

#BUILD AND RUN APP
export JAVA_HOME=/usr/opt/java/jdk-17
export PATH=$PATH:/usr/opt/java/jdk-17/bin
export PATH=$PATH:/usr/opt/maven/apache-maven-3.8.4/bin

cd spring-tanzu-workshop/product-catalog-microservice

mvn -DskipTests clean package
mvn spring-boot:run

echo http://localhost:8082/swagger-ui/index.html#/







kubectl exec -it -n yb-dev-tanzu-yugabyte-universe yb-tserver-2 -- ycqlsh -f schema.cql
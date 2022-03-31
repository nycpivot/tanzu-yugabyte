kubectl get svc -A | grep tserver

read -p "External Url: " external_url

#export CQLSH_HOST=$external_url
#export CQLSH_PORT=9042

#BUILD CASSANDRA SCHEMA
yugabyte-2.13.0.1/bin/ycqlsh -f yugastore-java/resources/schema.cql $external_url 9042


#BUILD POSTGRES SCHEMA
yugabyte-2.13.0.1/bin/ysqlsh -h $external_url -p 5433 -f yugastore-java/resources/schema.sql


#BUILD DOTNET SCHEMA
yugabyte-2.13.0.1/bin/ysqlsh -h $external_url -p 5433 -f yugastore-java/resources/schema-dotnet.sql


export JAVA_HOME=/opt/java/jdk-17
export PATH=$PATH:/opt/java/jdk-17/bin
export PATH=$PATH:/opt/maven/apache-maven-3.8.5/bin


#LOAD TEST DATA
cd yugastore-java/resources
rm dataload.sh

cat <<EOF | tee dataload.sh
for i in products.json;
do
  python parse_metadata_json.py $i; 
  ./cassandra-loader -f cronos_products.csv -host $external_url -schema "cronos.products(asin, title, description, price, imUrl, also_bought, also_viewed, bought_together, buy_after_viewing, brand, categories,num_reviews,num_stars,avg_stars)" -maxInsertErrors 10000 -maxErrors 10000 -charsPerColumn 256000;
  ./cassandra-loader -f cronos_product_rankings.csv -host $external_url -schema "cronos.product_rankings(asin, category, sales_rank, title, price, imurl, num_reviews, num_stars, avg_stars)" -maxInsertErrors 10000 -maxErrors 10000 -charsPerColumn 256000;
  ./cassandra-loader -f cronos_product_inventory.csv -host $external_url -schema "cronos.product_inventory(asin, quantity)";
  rm *.csv*
done
EOF

./dataload.sh

cd $HOME

#\l 					SHOW DATABASES
#\c db-name;		CONNECT TO DATABASE

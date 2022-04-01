kubectl get svc -A | grep tserver

read -p "External Url: " external_url
export YB_TSERVER_URL=$external_url

#export CQLSH_HOST=$external_url
#export CQLSH_PORT=9042

#BUILD CASSANDRA SCHEMA (PRODUCTS, INVENTORY, ETC)
yugabyte-2.13.0.1/bin/ycqlsh -f tanzu-yugabyte/src/yugastore-java-master/resources/schema.cql $YB_TSERVER_URL 9042


#BUILD POSTGRES SCHEMA (CART - DATA IS WRITTEN BY APP)
yugabyte-2.13.0.1/bin/ysqlsh -h $YB_TSERVER_URL -p 5433 -f tanzu-yugabyte/src/yugastore-java-master/resources/schema.sql


#BUILD POSTGRES SCHEMA (DOTNET - DATA IS WRITTEN BY APP)
yugabyte-2.13.0.1/bin/ysqlsh -h $YB_TSERVER_URL -p 5433 -f tanzu-yugabyte/src/tanzu-yugabyte-dotnet/resources/schema.sql


#WRITE TEST DATA INTO CASSANDRA
cd tanzu-yugabyte/src/yugastore-java-master/resources
./dataload.sh

cd $HOME

#\l 					SHOW DATABASES
#\c db-name;	CONNECT TO DATABASE
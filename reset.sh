read -p "Universe name: " universe_name

kubectl delete pv --all
kubectl delete sc yugabyte-data

kubectl delete ns $universe_name
kubectl delete ns yb-platform

docker kill $(docker ps -q)
docker rm $(docker ps -a -q)
docker rmi $(docker images -q)

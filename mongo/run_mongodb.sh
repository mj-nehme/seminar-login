#!/bin/bash
pushd /Users/jaafar/seminar/mongo/

docker network create --subnet=172.19.0.0/24 seminar-net
sudo docker build --tag mongodb .
docker run --name mongodb-cr -p 27017:27017 --ip 172.19.0.5 --expose 27017 --net seminar-net -d mongodb
docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' mongodb-cr
popd

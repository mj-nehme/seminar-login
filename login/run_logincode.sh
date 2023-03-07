#!/bin/bash

pushd /Users/jaafar/seminar/login/
sudo docker build --build-arg MONGODB_IP="172.19.0.5" --tag seminar-gocode .
docker run --name gocode-cr --ip 172.19.0.4 --expose 80 -p 80:80 --net seminar-net -d seminar-gocode
docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' gocode-cr
popd

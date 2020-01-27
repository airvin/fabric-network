#!/bin/bash

docker-compose -f docker-compose.yaml up -d orderer peer cli chaincode

docker ps -a

sleep 10

docker exec cli peer channel create -c myc -f myc.tx -o orderer:7050
docker exec cli peer channel join -b myc.block
docker exec cli peer channel list

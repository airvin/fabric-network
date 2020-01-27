## Fabric network

This Fabric network consists of an orderer, peer, cli and chaincode container.

To start the nodes and join the peer to the channel `myc`, run:

```
./start.sh
```

Then to start the chaincode in development mode, use the following:

```
docker exec -it chaincode bash
cd chaincode_example02/node
node chaincode_example02.js --peer.address peer:7052 --chaincode-id-name "mycc:v0"
```

In a separate terminal window, run:

```
docker exec -it cli bash
peer chaincode install -n mycc -v v0 -l node -p /opt/gopath/src/chaincodedev/chaincode/chaincode_example02/node
peer chaincode list --installed
peer chaincode instantiate -n mycc -v v0 -l node -c '{"Args":["init","a","100","b","200"]}' -C myc -o orderer:7050
```

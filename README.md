## Fabric network

This Fabric network consists of an orderer, peer, cli and chaincode container.

To start the nodes and join the peer to the channel `myc`, run:

```
./start.sh
```

### Chaincode Setup - Chaincode Container

Then to start the chaincode in development mode, use the following:

### Node Chaincode

```
docker exec -it chaincode bash
cd chaincode_example02/node
npm install
node chaincode_example02.js --peer.address peer:7052 --chaincode-id-name "mycc:v0"
```

### Go Chaincode

```
docker exec -t chaincode bash
cd chaincode_example02/go
go build -o example02
CORE_CHAINCODE_LOGGING_LEVEL=debug CORE_PEER_ADDRESS=peer:7052 CORE_CHAINCODE_ID_NAME=mycc:v0 ./example02
```

### Chaincode Testing - CLI Container 


In a separate terminal window, run:

### Node Chaincode

Instantiation:

```
docker exec -it cli bash
peer chaincode install -n mycc -v v0 -l node -p /opt/gopath/src/chaincodedev/chaincode/chaincode_example02/node
peer chaincode list --installed
peer chaincode instantiate -n mycc -v v0 -l node -c '{"Args":["init","a","100","b","200"]}' -C myc -o orderer:7050
```

Invocation:

```
peer chaincode invoke -n mycc -c '{"Args":["invoke","a","b","30"]}' -C myc
```

Query:

```
peer chaincode query -n mycc -c '{"Args":["query","a"}' -C myc
```

### Go Chaincode

Instantiation:

For the Go chaincode we need to provide a relative path to `/opt/gopath/src`

```
docker exec -it cli bash
peer chaincode install -n mycc -v v0 -l golang -p chaincodedev/chaincode/chaincode_example02/go
peer chaincode list --installed
peer chaincode instantiate -n mycc -v v0 -l golang -c '{"Args":["init","a","100","b","200"]}' -C myc -o orderer:7050
```

Invocation:

```
peer chaincode invoke -n mycc -c '{"Args":["invoke","a","b","30"]}' -C myc
```

Query:

```
peer chaincode query -n mycc -c '{"Args":["query","a"}' -C myc
```


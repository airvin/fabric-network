## Fabric network

This Fabric network consists of an orderer, peer, cli and chaincode container.

To start the nodes and join the peer to the channel `myc`, run:

```
./start.sh
```

or, to run without the chaincode container (for local dev):

```
./start-no-cc.sh
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

### Notes on Running the Chaincode Process Locally

In this setup there is no need to run the chaincode container, but we will be hosting the process that implements the chaincode on our host machine. The only change we need to do is to make port 7052 of the peer accessible from outside the docker-compose network created for the fabric deployment. To do that it is sufficient to add the mapping: `- 7052:7052` under the ports section of the `peer` container in the `docker-compose.yaml`.

#### Node Chaincode

The current version of the `fabric_shim` package requires an older version of node to be compiled successfully. To do that we will be using the [n](https://github.com/tj/n) verions manager.

With the fabric network running do the following:

```
# npm install n
sudo n 8.9.0
cd chaincode/chaincode_example02/node
npm install
node chaincode_example02.js --peer.address localhost:7052 --chaincode-id-name "mycc:v0"
```

#### Go Chaincode

*TO BE DONE*

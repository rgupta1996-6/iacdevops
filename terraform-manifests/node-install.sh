mkdir substrate-as
mv vtb-node ./substrate-as
chmod 777 substrate-as
chmod 777 ./substrate-as/vtb-node
cd substrate-as/
nohup ./vtb-node --base-path /tmp/vtb-node/temp02 --chain local --name hodl-validator-node1  --charlie --port 30337 --ws-port 9947 --rpc-port 9937 --validator --offchain-worker Never >> /home/ubuntu/substrate-as/node1.log 2>&1 &
sleep 1
nohup ./vtb-node  --base-path /tmp/vtb-node/temp04 --chain local --name hodl-validator-node1  --alice --port 30335 --ws-port 9945 --rpc-port 9935 --enable-offchain-indexing true  --unsafe-rpc-external --rpc-cors=all --unsafe-ws-external --validator >> /home/ubuntu/substrate-as/node2.log 2>&1 &
sleep 1
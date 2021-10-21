mkdir substrate-as
mv vtb-node ./substrate-as
mv demo.log ./substrate-as
chmod 777 substrate-as
chmod 777 ./substrate-as/vtb-node
chmod 777 ./substrate-as/demo.log
cd substrate-as/
nohup ./vtb-node  --base-path /tmp/vtb-node/temp04 --chain local --name hodl-validator-node1  --alice --port 30335 --ws-port 9945 --rpc-port 9935 --enable-offchain-indexing true  --unsafe-rpc-external --rpc-cors=all --unsafe-ws-external --validator  --bootnodes /ip4/${node1_endpoint}/tcp/30335/p2p/`cat demo.log`  >> /home/ubuntu/substrate-as/node2.log 2>&1 &
sleep 2
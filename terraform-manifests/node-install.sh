mkdir substrate-as
mv vtb-node ./substrate-as
chmod 777 substrate-as
chmod 777 ./substrate-as/vtb-node
cd substrate-as/
nohup ./vtb-node --base-path /tmp/vtb-node/temp02 --chain local --name hodl-validator-node1  --charlie --port 30337 --ws-port 9947 --rpc-port 9937 --validator --offchain-worker Never >> /home/ubuntu/substrate-as/node1.log 2>&1 &
sleep 2
grep identity node1.log | awk -F': ' '{print $2}' > demo.log
hostname -I | awk '{print $1}' > node1-ip.log
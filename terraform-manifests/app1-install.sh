#! /bin/bash
sudo bash -c 'cat >/etc/systemd/system/pingservice.service <<EOL
[Unit]
Description=Go Server

[Service]
ExecStart=/home/ubuntu/pingservice
User=root
Group=root
Restart=always

[Install]
WantedBy=multi-user.target
EOL'

sudo systemctl enable pingservice.service
sudo systemctl start pingservice.service
sudo systemctl is-active pingservice.service
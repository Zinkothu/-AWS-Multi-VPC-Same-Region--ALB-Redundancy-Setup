#!/bin/bash
set -xe

sudo apt-get update -y
sudo apt-get install -y unzip curl

curl -L https://github.com/nicholasjackson/fake-service/releases/download/v0.26.2/fake_service_linux_amd64.zip -o /tmp/service.zip
unzip -o /tmp/service.zip -d /tmp/
sudo mv /tmp/fake-service /usr/local/bin/statement-service
sudo chmod 755 /usr/local/bin/statement-service

cat > /etc/systemd/system/statement-api.service <<EOF
[Unit]
Description=Statement API Service
After=network.target

[Service]
Type=simple
User=ubuntu
Environment="LISTEN_ADDR=${listen_addr}"
Environment="MESSAGE=${message}"
Environment="NAME=${name}"
ExecStart=/usr/local/bin/statement-service
Restart=always

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable statement-api.service
sudo systemctl restart statement-api.service
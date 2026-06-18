#!/bin/bash
set -xe

sudo apt-get update -y
sudo apt-get install -y unzip curl

curl -L https://github.com/nicholasjackson/fake-service/releases/download/v0.26.2/fake_service_linux_amd64.zip -o /tmp/service.zip
unzip -o /tmp/service.zip -d /tmp/
sudo mv /tmp/fake-service /usr/local/bin/customer-profile-service
sudo chmod 755 /usr/local/bin/customer-profile-service

cat > /etc/systemd/system/customer-profile-api.service <<EOF
[Unit]
Description=Customer Profile API Service
After=network.target

[Service]
Type=simple
User=ubuntu
Environment="LISTEN_ADDR=${listen_addr}"
Environment="UPSTREAM_URIS=https://account.internal.hellocloudteam4app.click"
Environment="MESSAGE=${message}"
Environment="NAME=${name}"
ExecStart=/usr/local/bin/customer-profile-service
Restart=always

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable customer-profile-api.service
sudo systemctl restart customer-profile-api.service
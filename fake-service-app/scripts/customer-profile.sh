#!/bin/bash
set -xe

echo "Installing dependencies"
sudo apt-get update -y
sudo apt-get install -y unzip curl

echo "Downloading fake-service"

curl -L https://github.com/nicholasjackson/fake-service/releases/download/v0.26.2/fake_service_linux_amd64.zip -o /tmp/customer-profile.zip

unzip -o /tmp/customer-profile.zip -d /tmp/

# FIX: correct binary path
sudo mv /tmp/fake-service /usr/local/bin/customer-profile-service
sudo chmod 755 /usr/local/bin/customer-profile-service

echo "Creating systemd service"

cat > /etc/systemd/system/customer-profile-api.service <<EOF

[Unit]
Description=Customer Profile API Service
After=network.target

[Service]
Type=simple
User=ubuntu
Group=ubuntu
ExecStart=/usr/local/bin/customer-profile-service

Environment="LISTEN_ADDR=${listen_addr}"
Environment="UPSTREAM_URIS=http://${account_ip}:8080"
Environment="MESSAGE=HelloCloud Bank | Retail-Banking | Customer-profile-service"
Environment="NAME=customer-profile-service"

Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

echo "Reloading systemd"
sudo systemctl daemon-reload
sudo systemctl enable customer-profile-api.service
sudo systemctl restart customer-profile-api.service

sleep 3
sudo systemctl status customer-profile-api.service --no-pager
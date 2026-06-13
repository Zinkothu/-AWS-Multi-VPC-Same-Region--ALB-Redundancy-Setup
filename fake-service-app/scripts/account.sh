#!/bin/bash
set -xe

apt-get update -y
apt-get install -y unzip curl

curl -L https://github.com/nicholasjackson/fake-service/releases/download/v0.26.2/fake_service_linux_amd64.zip -o /tmp/account-service.zip
unzip -o /tmp/account-service.zip -d /tmp/
mv /tmp/fake-service /usr/local/bin/account-service
chmod 755 /usr/local/bin/account-service

cat > /etc/systemd/system/account-service.service << EOF
[Unit]
Description=Account API Service
After=network.target

[Service]
Type=simple
User=ubuntu
Group=ubuntu
ExecStart=/usr/local/bin/account-service

Environment="LISTEN_ADDR=${listen_addr}"
Environment="UPSTREAM_URIS=http://${statement_ip}:8080"
Environment="MESSAGE=${message}"
Environment="NAME=${name}"

Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable account-service.service
systemctl restart account-service.service

sleep 3
systemctl status account-service.service --no-pager
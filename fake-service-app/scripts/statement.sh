#!/bin/bash
set -xe

# 1. Use apt-get for Ubuntu
apt-get update -y
apt-get install -y unzip curl

# 2. Use /tmp for downloads and cleanup
curl -L https://github.com/nicholasjackson/fake-service/releases/download/v0.26.2/fake_service_linux_amd64.zip -o /tmp/statement-service.zip
unzip -o /tmp/statement-service.zip -d /tmp/

# 3. Move to a standard binary path
mv /tmp/fake-service /usr/local/bin/statement-service
chmod 755 /usr/local/bin/statement-service

# 4. Correct Ubuntu systemd path and remove 'EOF' quotes
cat > /etc/systemd/system/statement-service.service << EOF
[Unit]
Description=Statement API Service
After=network.target

[Service]
Type=simple
User=ubuntu
Group=ubuntu
ExecStart=/usr/local/bin/statement-service

Environment="LISTEN_ADDR=${listen_addr}"
Environment="MESSAGE=HelloCloud Bank | Retail-Banking | Statement-service"
Environment="NAME=statement-service"

Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

# 5. Start the service
systemctl daemon-reload
systemctl enable statement-service.service
systemctl restart statement-service.service

# 6. Verify
sleep 3
systemctl status statement-service.service --no-pager
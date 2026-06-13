#!/bin/bash
exec > /var/log/counting-service.log 2>&1
set -xe

echo "Starting counting service setup"

# Force IPv4 for apt
echo 'Acquire::ForceIPv4 "true";' | sudo tee /etc/apt/apt.conf.d/99force-ipv4

# Install only what's needed
sudo apt-get -o Acquire::ForceIPv4=true update -y || true
sudo apt-get -o Acquire::ForceIPv4=true install unzip curl -y || true

# Download and install counting service
sudo curl -4 -L https://github.com/hashicorp/demo-consul-101/releases/download/v0.0.5/counting-service_linux_amd64.zip -o /tmp/counting-service.zip
sudo unzip /tmp/counting-service.zip -d /tmp/
sudo mv /tmp/counting-service_linux_amd64 /usr/bin/counting-service
sudo chmod 755 /usr/bin/counting-service
sudo chown ubuntu:ubuntu /usr/bin/counting-service

# Verify binary
if [ ! -f /usr/bin/counting-service ]; then
    echo "ERROR: Binary not found!"
    exit 1
fi

# Create systemd service
sudo tee /usr/lib/systemd/system/counting-api.service << 'EOF'
[Unit]
Description=counting API service
After=syslog.target network.target

[Service]
Environment=PORT="9000"
ExecStart=/usr/bin/counting-service
User=ubuntu
Group=ubuntu
ExecStop=/bin/sleep 5
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable counting-api.service
sudo systemctl start counting-api.service
sleep 3
sudo systemctl status counting-api.service

echo "Counting service setup complete!"
# Generate private key
resource "tls_private_key" "dashboard_counting_app" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

# Key pair in AWS
resource "aws_key_pair" "dashboard_counting_app" {
  key_name   = "dashboard-counting-app-ssh-key"
  public_key = tls_private_key.dashboard_counting_app.public_key_openssh
}

# Save private key locally
resource "local_file" "private_key" {
  content         = tls_private_key.dashboard_counting_app.private_key_pem
  filename        = "dashboard-counting-app.pem"
  file_permission = "0400"
}
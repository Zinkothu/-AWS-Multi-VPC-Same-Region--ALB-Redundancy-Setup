data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name = "name"
    # values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}



resource "aws_instance" "customer-profile_app" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.fake_service_app.key_name
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.customer_public.id
  vpc_security_group_ids      = [aws_security_group.customer-profile.id]

  depends_on = [aws_instance.account_app]

  user_data = templatefile("./scripts/customer-profile.sh", {
    listen_addr = "0.0.0.0:8080"
    message     = "HelloCloud Bank | Retail-Banking | Customer-profile-service"
    name        = "customer-profile"
    account_ip  = aws_instance.account_app.private_ip
  })

  tags = {
    Name = "customer-profile-app-instance"
  }
}

resource "aws_instance" "account_app" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.fake_service_app.key_name
  associate_public_ip_address = false
  subnet_id                   = aws_subnet.account_private.id
  vpc_security_group_ids      = [aws_security_group.account.id]

  depends_on = [aws_instance.statement_app]
  # Add this line to run the account script
  user_data = templatefile("./scripts/account.sh", {
    listen_addr  = "0.0.0.0:8080"
    message      = "HelloCloud Bank | Retail-Banking | Account-service"
    name         = "account"
    statement_ip = aws_instance.statement_app.private_ip
  })

  tags = {
    Name = "account-app-instance"
  }
}

resource "aws_instance" "statement_app" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.fake_service_app.key_name
  associate_public_ip_address = false
  subnet_id                   = aws_subnet.statement_private.id
  vpc_security_group_ids      = [aws_security_group.statement.id]

  user_data = templatefile("./scripts/statement.sh", {
    listen_addr = "0.0.0.0:8080",
    message     = "HelloCloud Bank | Retail-Banking | Statement-service",
    name        = "statement"
    # statement_ip = aws_instance.statement_app.private_ip
  })

  tags = {
    Name = "statement-app-instance"
  }
}
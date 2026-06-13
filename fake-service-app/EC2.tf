data "aws_ami" "ubuntu" {
  most_recent = true #always pick the latest image

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}

####
# CUSTOMER PROFILE EC2 (x2)
####

resource "aws_instance" "customer_profile_app_a" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.fake_service_app.key_name
  subnet_id              = aws_subnet.customer_private_a.id
  vpc_security_group_ids = [aws_security_group.customer_profile_ec2.id]

  depends_on = [aws_instance.account_app_a, aws_instance.account_app_b]

  user_data = templatefile("./scripts/customer-profile.sh", {
    listen_addr = "0.0.0.0:${var.customer_profile_port}"
    message     = "HelloCloud Bank | Retail-Banking | Customer-profile-service"
    name        = "customer-profile"
    account_alb_dns  = aws_lb.account.dns_name
  })

  tags = { Name = "customer-profile-app-a" }
}

resource "aws_instance" "customer_profile_app_b" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.fake_service_app.key_name
  subnet_id              = aws_subnet.customer_private_b.id
  vpc_security_group_ids = [aws_security_group.customer_profile_ec2.id]

  depends_on = [aws_instance.account_app_a, aws_instance.account_app_b]

  user_data = templatefile("./scripts/customer-profile.sh", {
    listen_addr = "0.0.0.0:${var.customer_profile_port}"
    message     = "HelloCloud Bank | Retail-Banking | Customer-profile-service"
    name        = "customer-profile"
    account_alb_dns  = aws_lb.account.dns_name
  })

  tags = { Name = "customer-profile-app-b" }
}

####
# ACCOUNT EC2 (x2)
####

resource "aws_instance" "account_app_a" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.fake_service_app.key_name
  subnet_id              = aws_subnet.account_private_a.id
  vpc_security_group_ids = [aws_security_group.account_ec2.id]

  depends_on = [aws_instance.statement_app_a, aws_instance.statement_app_b]

  user_data = templatefile("./scripts/account.sh", {
    listen_addr  = "0.0.0.0:${var.account_port}"
    message      = "HelloCloud Bank | Retail-Banking | Account-service"
    name         = "account"
    statement_alb_dns = aws_lb.statement.dns_name
  })

  tags = { Name = "account-app-a" }
}

resource "aws_instance" "account_app_b" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.fake_service_app.key_name
  subnet_id              = aws_subnet.account_private_b.id
  vpc_security_group_ids = [aws_security_group.account_ec2.id]

  depends_on = [aws_instance.statement_app_a, aws_instance.statement_app_b]

  user_data = templatefile("./scripts/account.sh", {
    listen_addr  = "0.0.0.0:${var.account_port}"
    message      = "HelloCloud Bank | Retail-Banking | Account-service"
    name         = "account"
    statement_alb_dns = aws_lb.statement.dns_name
  })

  tags = { Name = "account-app-b" }
}

####
# STATEMENT EC2 (x2)
####

resource "aws_instance" "statement_app_a" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.fake_service_app.key_name
  subnet_id              = aws_subnet.statement_private_a.id
  vpc_security_group_ids = [aws_security_group.statement_ec2.id]

  user_data = templatefile("./scripts/statement.sh", {
    listen_addr = "0.0.0.0:${var.statement_port}"
    message     = "HelloCloud Bank | Retail-Banking | Statement-service"
    name        = "statement"
  })

  tags = { Name = "statement-app-a" }
}

resource "aws_instance" "statement_app_b" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.fake_service_app.key_name
  subnet_id              = aws_subnet.statement_private_b.id
  vpc_security_group_ids = [aws_security_group.statement_ec2.id]

  user_data = templatefile("./scripts/statement.sh", {
    listen_addr = "0.0.0.0:${var.statement_port}"
    message     = "HelloCloud Bank | Retail-Banking | Statement-service"
    name        = "statement"
  })

  tags = { Name = "statement-app-b" }
}


####
# BASTION HOST
# ####

# resource "aws_instance" "bastion" {
#   ami                         = data.aws_ami.ubuntu.id
#   instance_type               = var.instance_type
#   key_name                    = aws_key_pair.fake_service_app.key_name
#   subnet_id                   = aws_subnet.customer_public_a.id
#   vpc_security_group_ids      = [aws_security_group.bastion.id]
#   associate_public_ip_address = true

#   tags = { Name = "bastion" }
# }


resource "aws_instance" "bastion" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t3.micro"
  key_name                    = aws_key_pair.fake_service_app.key_name
  subnet_id                   = aws_subnet.customer_public_a.id
  vpc_security_group_ids      = [aws_security_group.bastion.id]
  associate_public_ip_address = true

  provisioner "file" {
    source      = local_file.private_key.filename
    destination = "/home/ubuntu/fake-service-app.pem"

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = tls_private_key.fake_service_app.private_key_pem
      host        = self.public_ip
    }
  }

  provisioner "remote-exec" {
    inline = ["chmod 400 /home/ubuntu/fake-service-app.pem"]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = tls_private_key.fake_service_app.private_key_pem
      host        = self.public_ip
    }
  }

  tags = { Name = "bastion" }
}
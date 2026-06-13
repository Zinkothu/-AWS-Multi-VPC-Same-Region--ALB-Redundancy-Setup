####
# CUSTOMER PROFILE
####

resource "aws_security_group" "customer_profile_alb" {
  name   = "customer-profile-alb-sg"
  vpc_id = aws_vpc.customer-profile.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # ingress {
  #   from_port       = 22
  #   to_port         = 22
  #   protocol        = "tcp"
  #   security_groups = [aws_security_group.bastion.id]
  # }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "customer-profile-alb-sg" }
}

resource "aws_security_group" "customer_profile_ec2" {
  name   = "customer-profile-ec2-sg"
  vpc_id = aws_vpc.customer-profile.id

  ingress {
    from_port       = var.customer_profile_port
    to_port         = var.customer_profile_port
    protocol        = "tcp"
    security_groups = [aws_security_group.customer_profile_alb.id]
  }
  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "customer-profile-ec2-sg" }
}

####
# ACCOUNT
####

resource "aws_security_group" "account_alb" {
  name   = "account-alb-sg"
  vpc_id = aws_vpc.account.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.customer-profile_vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "account-alb-sg" }
}

resource "aws_security_group" "account_ec2" {
  name   = "account-ec2-sg"
  vpc_id = aws_vpc.account.id

  ingress {
    from_port       = var.account_port
    to_port         = var.account_port
    protocol        = "tcp"
    security_groups = [aws_security_group.account_alb.id]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]       
  }

  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "account-ec2-sg" }
}

####
# STATEMENT
####

resource "aws_security_group" "statement_alb" {
  name   = "statement-alb-sg"
  vpc_id = aws_vpc.statement.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.account_vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "statement-alb-sg" }
}

resource "aws_security_group" "statement_ec2" {
  name   = "statement-ec2-sg"
  vpc_id = aws_vpc.statement.id

  ingress {
    from_port       = var.statement_port
    to_port         = var.statement_port
    protocol        = "tcp"
    security_groups = [aws_security_group.statement_alb.id]
  }

    ingress {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["10.0.0.0/16"]       
    }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "statement-ec2-sg" }
}


####
# BASTION
####

resource "aws_security_group" "bastion" {
  name   = "bastion-sg"
  vpc_id = aws_vpc.customer-profile.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "bastion-sg" }
}

###################################################
# SECURITY GROUPS
###################################################

resource "aws_security_group" "dashboard-sg" {
  name   = "dashboard-sg"
  vpc_id = aws_vpc.dashboard.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "dashboard-sg"
  }
}

resource "aws_security_group" "counting-sg" {
  name   = "counting-sg"
  vpc_id = aws_vpc.counting.id


  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.dashboard_vpc_cidr]
  }

  # Accept response traffic from statement-vpc
  ingress {
    from_port   = 9000
    to_port     = 9000
    protocol    = "tcp"
    cidr_blocks = [var.dashboard_vpc_cidr]
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "icmp"
    cidr_blocks = [var.dashboard_vpc_cidr]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "counting-sg"
  }
}

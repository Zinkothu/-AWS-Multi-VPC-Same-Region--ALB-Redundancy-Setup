###################################################
# Dashboard VPC
###################################################

resource "aws_vpc" "dashboard" {
  cidr_block           = var.dashboard_vpc_cidr
  enable_dns_hostnames = true

  tags = {
    Name = "dashboard-vpc"
  }
}

resource "aws_subnet" "dashboard_public" {
  vpc_id                  = aws_vpc.dashboard.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "dashboard-public-subnet"
  }
}

resource "aws_subnet" "dashboard_private" {
  vpc_id     = aws_vpc.dashboard.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "dashboard-private-subnet"
  }
}

resource "aws_internet_gateway" "dashboard_igw" {
  vpc_id = aws_vpc.dashboard.id

  tags = {
    Name = "dashboard-igw"
  }
}

###################################################
# Counting VPC
###################################################

resource "aws_vpc" "counting" {
  cidr_block           = var.counting_vpc_cidr
  enable_dns_hostnames = true

  tags = {
    Name = "counting-vpc"
  }
}

resource "aws_subnet" "counting_public" {
  vpc_id                  = aws_vpc.counting.id
  cidr_block              = "172.16.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "counting-public-subnet"
  }
}

resource "aws_subnet" "counting_private" {
  vpc_id     = aws_vpc.counting.id
  cidr_block = "172.16.2.0/24"

  tags = {
    Name = "counting-private-subnet"
  }
}

resource "aws_internet_gateway" "counting" {
  vpc_id = aws_vpc.counting.id

  tags = {
    Name = "counting-igw"
  }
}

resource "aws_eip" "counting_nat" {
  domain = "vpc"
}

resource "aws_nat_gateway" "counting" {
  allocation_id = aws_eip.counting_nat.id
  subnet_id     = aws_subnet.counting_public.id

  depends_on = [aws_internet_gateway.counting]
}


###################################################
# VPC PEERING
###################################################

resource "aws_vpc_peering_connection" "dashboard_counting" {
  vpc_id      = aws_vpc.dashboard.id
  peer_vpc_id = aws_vpc.counting.id
  auto_accept = true
  accepter {
    allow_remote_vpc_dns_resolution = true
  }

  requester {
    allow_remote_vpc_dns_resolution = true
  }

  tags = {
    Name = "dashboard-counting-peer"
  }
}

###################################################
# ROUTE TABLES
###################################################

resource "aws_route_table" "dashboard_public" {
  vpc_id = aws_vpc.dashboard.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.dashboard_igw.id
  }

  route {
    cidr_block                = var.counting_vpc_cidr
    vpc_peering_connection_id = aws_vpc_peering_connection.dashboard_counting.id
  }

  tags = {
    Name = "dashboard-public-rt"
  }
}

resource "aws_route_table_association" "dashboard_public" {
  subnet_id      = aws_subnet.dashboard_public.id
  route_table_id = aws_route_table.dashboard_public.id
}


###################################################
# ROUTE TABLES - Counting VPC
###################################################

resource "aws_route_table" "counting_public" {
  vpc_id = aws_vpc.counting.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.counting.id
  }


  tags = {
    Name = "counting-public-rt"
  }
}

resource "aws_route_table_association" "counting_public" {
  subnet_id      = aws_subnet.counting_public.id
  route_table_id = aws_route_table.counting_public.id
}




resource "aws_route_table" "counting_private" {
  vpc_id = aws_vpc.counting.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.counting.id
  }

  route {
    cidr_block                = var.dashboard_vpc_cidr # dashboard public subnet
    vpc_peering_connection_id = aws_vpc_peering_connection.dashboard_counting.id
  }

  tags = {
    Name = "counting-private-rt"
  }
}

resource "aws_route_table_association" "counting_private" {
  subnet_id      = aws_subnet.counting_private.id
  route_table_id = aws_route_table.counting_private.id
}
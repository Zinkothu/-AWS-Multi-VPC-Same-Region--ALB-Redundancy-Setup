###################################################
# CUSTOMER PROFILE VPC
###################################################

resource "aws_vpc" "customer-profile" {
  cidr_block           = var.customer-profile_vpc_cidr
  enable_dns_hostnames = true

  tags = {
    Name = "customer-profile-vpc"
  }
}

resource "aws_subnet" "customer_public" {
  vpc_id                  = aws_vpc.customer-profile.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "customer-profile-public-subnet"
  }
}

resource "aws_subnet" "customer_private" {
  vpc_id     = aws_vpc.customer-profile.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "customer-profile-private-subnet"
  }
}

resource "aws_internet_gateway" "customer-profile" {
  vpc_id = aws_vpc.customer-profile.id

  tags = {
    Name = "customer-profile-igw"
  }
}

###################################################
# ACCOUNT VPC
###################################################

resource "aws_vpc" "account" {
  cidr_block           = var.account_vpc_cidr
  enable_dns_hostnames = true

  tags = {
    Name = "account-vpc"
  }
}

resource "aws_subnet" "account_public" {
  vpc_id                  = aws_vpc.account.id
  cidr_block              = "172.16.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "account-public-subnet"
  }
}

resource "aws_subnet" "account_private" {
  vpc_id     = aws_vpc.account.id
  cidr_block = "172.16.2.0/24"

  tags = {
    Name = "account-private-subnet"
  }
}

resource "aws_internet_gateway" "account" {
  vpc_id = aws_vpc.account.id

  tags = {
    Name = "account-igw"
  }
}



###################################################
# STATEMENT VPC
###################################################

resource "aws_vpc" "statement" {
  cidr_block           = var.statement_vpc_cidr
  enable_dns_hostnames = true

  tags = {
    Name = "statement-vpc"
  }
}

resource "aws_subnet" "statement_public" {
  vpc_id                  = aws_vpc.statement.id
  cidr_block              = "192.168.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "statement-public-subnet"
  }
}

resource "aws_subnet" "statement_private" {
  vpc_id     = aws_vpc.statement.id
  cidr_block = "192.168.2.0/24"

  tags = {
    Name = "statement-private-subnet"
  }
}

resource "aws_internet_gateway" "statement" {
  vpc_id = aws_vpc.statement.id

  tags = {
    Name = "statement-igw"
  }
}



###################################################
# ROUTE TABLES
###################################################

resource "aws_route_table" "customer_public" {
  vpc_id = aws_vpc.customer-profile.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.customer-profile.id
  }

  route {
    cidr_block                = var.account_vpc_cidr
    vpc_peering_connection_id = aws_vpc_peering_connection.customer_account.id
  }
}

resource "aws_route_table_association" "customer_public" {
  subnet_id      = aws_subnet.customer_public.id
  route_table_id = aws_route_table.customer_public.id
}

resource "aws_route_table" "account_public" {
  vpc_id = aws_vpc.account.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.account.id
  }

  route {
    cidr_block                = var.customer-profile_vpc_cidr
    vpc_peering_connection_id = aws_vpc_peering_connection.customer_account.id
  }
}

resource "aws_route_table" "account_private" {
  vpc_id = aws_vpc.account.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.account.id
  }

  route {
    cidr_block                = var.statement_vpc_cidr
    vpc_peering_connection_id = aws_vpc_peering_connection.account_statement.id
  }

  route {
    cidr_block                = var.customer-profile_vpc_cidr
    vpc_peering_connection_id = aws_vpc_peering_connection.customer_account.id
  }
}

resource "aws_route_table_association" "account_public" {
  subnet_id      = aws_subnet.account_public.id
  route_table_id = aws_route_table.account_public.id
}

resource "aws_route_table_association" "account_private" {
  subnet_id      = aws_subnet.account_private.id
  route_table_id = aws_route_table.account_private.id
}

resource "aws_route_table" "statement_public" {
  vpc_id = aws_vpc.statement.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.statement.id
  }
}

resource "aws_route_table" "statement_private" {
  vpc_id = aws_vpc.statement.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.statement.id
  }

  route {
    cidr_block                = var.account_vpc_cidr
    vpc_peering_connection_id = aws_vpc_peering_connection.account_statement.id
  }
}

resource "aws_route_table_association" "statement_public" {
  subnet_id      = aws_subnet.statement_public.id
  route_table_id = aws_route_table.statement_public.id
}

resource "aws_route_table_association" "statement_private" {
  subnet_id      = aws_subnet.statement_private.id
  route_table_id = aws_route_table.statement_private.id
}
####
# CUSTOMER PROFILE VPC
####

resource "aws_vpc" "customer-profile" {
  cidr_block           = var.customer-profile_vpc_cidr
  enable_dns_hostnames = true
  tags                 = { Name = "customer-profile-vpc" }
}

resource "aws_subnet" "customer_public_a" {
  vpc_id                  = aws_vpc.customer-profile.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-southeast-1a"
  map_public_ip_on_launch = true
  tags                    = { Name = "customer-profile-public-subnet-a" }
}

resource "aws_subnet" "customer_public_b" {
  vpc_id                  = aws_vpc.customer-profile.id
  cidr_block              = "10.0.4.0/24"
  availability_zone       = "ap-southeast-1b"
  map_public_ip_on_launch = true
  tags                    = { Name = "customer-profile-public-subnet-b" }
}

resource "aws_subnet" "customer_private_a" {
  vpc_id            = aws_vpc.customer-profile.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "ap-southeast-1a"
  tags              = { Name = "customer-profile-private-subnet-a" }
}

resource "aws_subnet" "customer_private_b" {
  vpc_id            = aws_vpc.customer-profile.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "ap-southeast-1b"
  tags              = { Name = "customer-profile-private-subnet-b" }
}

resource "aws_internet_gateway" "customer-profile" {
  vpc_id = aws_vpc.customer-profile.id
  tags   = { Name = "customer-profile-igw" }
}

####
# ACCOUNT VPC
####

resource "aws_vpc" "account" {
  cidr_block           = var.account_vpc_cidr
  enable_dns_hostnames = true
  tags                 = { Name = "account-vpc" }
}

resource "aws_subnet" "account_public_a" {
  vpc_id                  = aws_vpc.account.id
  cidr_block              = "172.16.1.0/24"
  availability_zone       = "ap-southeast-1a"
  map_public_ip_on_launch = true
  tags                    = { Name = "account-public-subnet-a" }
}

resource "aws_subnet" "account_private_a" {
  vpc_id            = aws_vpc.account.id
  cidr_block        = "172.16.2.0/24"
  availability_zone = "ap-southeast-1a"
  tags              = { Name = "account-private-subnet-a" }
}

resource "aws_subnet" "account_private_b" {
  vpc_id            = aws_vpc.account.id
  cidr_block        = "172.16.3.0/24"
  availability_zone = "ap-southeast-1b"
  tags              = { Name = "account-private-subnet-b" }
}

resource "aws_internet_gateway" "account" {
  vpc_id = aws_vpc.account.id
  tags   = { Name = "account-igw" }
}

####
# STATEMENT VPC
####

resource "aws_vpc" "statement" {
  cidr_block           = var.statement_vpc_cidr
  enable_dns_hostnames = true
  tags                 = { Name = "statement-vpc" }
}

resource "aws_subnet" "statement_public_a" {
  vpc_id                  = aws_vpc.statement.id
  cidr_block              = "192.168.1.0/24"
  availability_zone       = "ap-southeast-1a"
  map_public_ip_on_launch = true
  tags                    = { Name = "statement-public-subnet-a" }
}

resource "aws_subnet" "statement_private_a" {
  vpc_id            = aws_vpc.statement.id
  cidr_block        = "192.168.2.0/24"
  availability_zone = "ap-southeast-1a"
  tags              = { Name = "statement-private-subnet-a" }
}

resource "aws_subnet" "statement_private_b" {
  vpc_id            = aws_vpc.statement.id
  cidr_block        = "192.168.3.0/24"
  availability_zone = "ap-southeast-1b"
  tags              = { Name = "statement-private-subnet-b" }
}

resource "aws_internet_gateway" "statement" {
  vpc_id = aws_vpc.statement.id
  tags   = { Name = "statement-igw" }
}

####
# ROUTE TABLES
####

# Customer Profile Public
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

  tags = { Name = "customer-profile-public-rt" }
}

resource "aws_route_table_association" "customer_public_a" {
  subnet_id      = aws_subnet.customer_public_a.id
  route_table_id = aws_route_table.customer_public.id
}

resource "aws_route_table_association" "customer_public_b" {
  subnet_id      = aws_subnet.customer_public_b.id
  route_table_id = aws_route_table.customer_public.id
}

# Customer Profile Private
resource "aws_route_table" "customer_private" {
  vpc_id = aws_vpc.customer-profile.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.customer.id
  }

  route {
    cidr_block                = var.account_vpc_cidr
    vpc_peering_connection_id = aws_vpc_peering_connection.customer_account.id
  }

  tags = { Name = "customer-profile-private-rt" }
}

resource "aws_route_table_association" "customer_private_a" {
  subnet_id      = aws_subnet.customer_private_a.id
  route_table_id = aws_route_table.customer_private.id
}

resource "aws_route_table_association" "customer_private_b" {
  subnet_id      = aws_subnet.customer_private_b.id
  route_table_id = aws_route_table.customer_private.id
}

# Account Public
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

  tags = { Name = "account-public-rt" }
}

resource "aws_route_table_association" "account_public_a" {
  subnet_id      = aws_subnet.account_public_a.id
  route_table_id = aws_route_table.account_public.id
}

# Account Private
resource "aws_route_table" "account_private" {
  vpc_id = aws_vpc.account.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.account.id
  }

  route {
    cidr_block                = var.customer-profile_vpc_cidr
    vpc_peering_connection_id = aws_vpc_peering_connection.customer_account.id
  }

  route {
    cidr_block                = var.statement_vpc_cidr
    vpc_peering_connection_id = aws_vpc_peering_connection.account_statement.id
  }

  tags = { Name = "account-private-rt" }
}

resource "aws_route_table_association" "account_private_a" {
  subnet_id      = aws_subnet.account_private_a.id
  route_table_id = aws_route_table.account_private.id
}

resource "aws_route_table_association" "account_private_b" {
  subnet_id      = aws_subnet.account_private_b.id
  route_table_id = aws_route_table.account_private.id
}

# Statement Public
resource "aws_route_table" "statement_public" {
  vpc_id = aws_vpc.statement.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.statement.id
  }

  tags = { Name = "statement-public-rt" }
}

resource "aws_route_table_association" "statement_public_a" {
  subnet_id      = aws_subnet.statement_public_a.id
  route_table_id = aws_route_table.statement_public.id
}

# Statement Private
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

  tags = { Name = "statement-private-rt" }
}

resource "aws_route_table_association" "statement_private_a" {
  subnet_id      = aws_subnet.statement_private_a.id
  route_table_id = aws_route_table.statement_private.id
}

resource "aws_route_table_association" "statement_private_b" {
  subnet_id      = aws_subnet.statement_private_b.id
  route_table_id = aws_route_table.statement_private.id
}
# Customer Profile NAT Gateway
resource "aws_eip" "customer_nat" {
  domain = "vpc"
}

resource "aws_nat_gateway" "customer" {
  allocation_id = aws_eip.customer_nat.id
  subnet_id     = aws_subnet.customer_public_a.id

  depends_on = [aws_internet_gateway.customer-profile]
}

# Account NAT Gateway
resource "aws_eip" "account_nat" {
  domain = "vpc"
}

resource "aws_nat_gateway" "account" {
  allocation_id = aws_eip.account_nat.id
  subnet_id     = aws_subnet.account_public_a.id

  depends_on = [aws_internet_gateway.account]
}

# Statement NAT Gateway
resource "aws_eip" "statement_nat" {
  domain = "vpc"
}

resource "aws_nat_gateway" "statement" {
  allocation_id = aws_eip.statement_nat.id
  subnet_id     = aws_subnet.statement_public_a.id

  depends_on = [aws_internet_gateway.statement]
}
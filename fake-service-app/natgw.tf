resource "aws_eip" "account_nat" {
  domain = "vpc"
}

resource "aws_nat_gateway" "account" {
  allocation_id = aws_eip.account_nat.id
  subnet_id     = aws_subnet.account_public.id

  depends_on = [aws_internet_gateway.account]
}



resource "aws_eip" "statement_nat" {
  domain = "vpc"
}

resource "aws_nat_gateway" "statement" {
  allocation_id = aws_eip.statement_nat.id
  subnet_id     = aws_subnet.statement_public.id

  depends_on = [aws_internet_gateway.statement]
}
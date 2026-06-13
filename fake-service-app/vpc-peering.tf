resource "aws_vpc_peering_connection" "customer_account" {
  vpc_id      = aws_vpc.customer-profile.id
  peer_vpc_id = aws_vpc.account.id
  auto_accept = true

  tags = {
    Name = "customer-account-peer"
  }
}

resource "aws_vpc_peering_connection_options" "customer_account_dns" {
  vpc_peering_connection_id = aws_vpc_peering_connection.customer_account.id

  requester {
    allow_remote_vpc_dns_resolution = true
  }

  accepter {
    allow_remote_vpc_dns_resolution = true
  }
}


resource "aws_vpc_peering_connection" "account_statement" {
  vpc_id      = aws_vpc.account.id
  peer_vpc_id = aws_vpc.statement.id
  auto_accept = true

  tags = {
    Name = "account-statement-peer"
  }
}

resource "aws_vpc_peering_connection_options" "account_statement_dns" {
  vpc_peering_connection_id = aws_vpc_peering_connection.account_statement.id

  requester {
    allow_remote_vpc_dns_resolution = true
  }

  accepter {
    allow_remote_vpc_dns_resolution = true
  }
}


# ###################################################
# # VPC PEERING
# ###################################################

# resource "aws_vpc_peering_connection" "customer_account" {
#   vpc_id      = aws_vpc.customer-profile.id
#   peer_vpc_id = aws_vpc.account.id
#   auto_accept = true
#   accepter {
#     allow_remote_vpc_dns_resolution = true
#   }

#   requester {
#     allow_remote_vpc_dns_resolution = true
#   }

#   tags = {
#     Name = "customer-account-peer"
#   }
# }

# resource "aws_vpc_peering_connection" "account_statement" {
#   vpc_id      = aws_vpc.account.id
#   peer_vpc_id = aws_vpc.statement.id
#   auto_accept = true

#   accepter {
#     allow_remote_vpc_dns_resolution = true
#   }

#   requester {
#     allow_remote_vpc_dns_resolution = true
#   }
#   tags = {
#     Name = "account-statement-peer"
#   }
# }

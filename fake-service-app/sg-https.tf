####
# UPDATED SECURITY GROUPS FOR HTTPS
# Add these ingress rules to your existing security groups in sg.tf
####

####
# CUSTOMER PROFILE ALB - HTTPS INGRESS
####

resource "aws_security_group_rule" "customer_profile_alb_https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.customer_profile_alb.id
  description       = "Allow HTTPS from internet"
}

####
# ACCOUNT ALB - HTTPS INGRESS
####

resource "aws_security_group_rule" "account_alb_https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = [var.customer-profile_vpc_cidr]
  security_group_id = aws_security_group.account_alb.id
  description       = "Allow HTTPS from Customer Profile VPC"
}

####
# STATEMENT ALB - HTTPS INGRESS
####

resource "aws_security_group_rule" "statement_alb_https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = [var.account_vpc_cidr]
  security_group_id = aws_security_group.statement_alb.id
  description       = "Allow HTTPS from Account VPC"
}

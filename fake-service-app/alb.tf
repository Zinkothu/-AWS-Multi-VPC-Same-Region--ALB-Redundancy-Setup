####
# CUSTOMER PROFILE ALB (Public)
####

resource "aws_lb" "customer_profile" {
  name               = "customer-profile-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.customer_profile_alb.id]
  subnets = [
    aws_subnet.customer_public_a.id,
    aws_subnet.customer_public_b.id
  ]

  tags = {
    Name = "customer-profile-alb"
  }
}

resource "aws_lb_target_group" "customer_profile" {
  name        = "customer-profile-tg"
  port        = var.customer_profile_port
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = aws_vpc.customer-profile.id

  health_check {
    path                = "/health"
    protocol            = "HTTP"
    port                = "traffic-port"
    interval            = 30
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name = "customer-profile-target-group"
  }
}

# resource "aws_lb_listener" "customer_profile" {
#   load_balancer_arn = aws_lb.customer_profile.arn
#   port              = 80
#   protocol          = "HTTP"

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.customer_profile.arn
#   }
# }

resource "aws_lb_target_group_attachment" "customer_profile_a" {
  target_group_arn = aws_lb_target_group.customer_profile.arn
  target_id        = aws_instance.customer_profile_app_a.id
  port             = var.customer_profile_port
}

resource "aws_lb_target_group_attachment" "customer_profile_b" {
  target_group_arn = aws_lb_target_group.customer_profile.arn
  target_id        = aws_instance.customer_profile_app_b.id
  port             = var.customer_profile_port
}

####
# ACCOUNT ALB (Internal)
####

resource "aws_lb" "account" {
  name               = "account-alb"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.account_alb.id]
  subnets = [
    aws_subnet.account_private_a.id,
    aws_subnet.account_private_b.id
  ]

  tags = {
    Name = "account-alb"
  }
}

resource "aws_lb_target_group" "account" {
  name        = "account-tg"
  port        = var.account_port
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = aws_vpc.account.id

  health_check {
    path                = "/health"
    protocol            = "HTTP"
    port                = "traffic-port"
    interval            = 30
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name = "account-target-group"
  }
}

# resource "aws_lb_listener" "account" {
#   load_balancer_arn = aws_lb.account.arn
#   port              = 80
#   protocol          = "HTTP"

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.account.arn
#   }
# }

resource "aws_lb_target_group_attachment" "account_a" {
  target_group_arn = aws_lb_target_group.account.arn
  target_id        = aws_instance.account_app_a.id
  port             = var.account_port
}

resource "aws_lb_target_group_attachment" "account_b" {
  target_group_arn = aws_lb_target_group.account.arn
  target_id        = aws_instance.account_app_b.id
  port             = var.account_port
}

####
# STATEMENT ALB (Internal)
####

resource "aws_lb" "statement" {
  name               = "statement-alb"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.statement_alb.id]
  subnets = [
    aws_subnet.statement_private_a.id,
    aws_subnet.statement_private_b.id
  ]

  tags = {
    Name = "statement-alb"
  }
}

resource "aws_lb_target_group" "statement" {
  name        = "statement-tg"
  port        = var.statement_port
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = aws_vpc.statement.id

  health_check {
    path                = "/health"
    protocol            = "HTTP"
    port                = "traffic-port"
    interval            = 30
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name = "statement-target-group"
  }
}

# resource "aws_lb_listener" "statement" {
#   load_balancer_arn = aws_lb.statement.arn
#   port              = 80
#   protocol          = "HTTP"

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.statement.arn
#   }
# }

resource "aws_lb_target_group_attachment" "statement_a" {
  target_group_arn = aws_lb_target_group.statement.arn
  target_id        = aws_instance.statement_app_a.id
  port             = var.statement_port
}

resource "aws_lb_target_group_attachment" "statement_b" {
  target_group_arn = aws_lb_target_group.statement.arn
  target_id        = aws_instance.statement_app_b.id
  port             = var.statement_port
}
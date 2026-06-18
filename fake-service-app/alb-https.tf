####
# UPDATED ALB CONFIGURATION WITH HTTPS
# Replace the listener sections in your alb.tf with these
####

####
# CUSTOMER PROFILE ALB LISTENERS (Public)
####

# HTTPS Listener (Primary)
resource "aws_lb_listener" "customer_profile_https" {
  load_balancer_arn = aws_lb.customer_profile.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn   = aws_acm_certificate_validation.customer_profile.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.customer_profile.arn
  }
}

# HTTP Listener (Redirect to HTTPS)
resource "aws_lb_listener" "customer_profile_http_redirect" {
  load_balancer_arn = aws_lb.customer_profile.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

####
# ACCOUNT ALB LISTENERS (Internal)
####

# HTTPS Listener (Primary)
resource "aws_lb_listener" "account_https" {
  load_balancer_arn = aws_lb.account.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn   = aws_acm_certificate_validation.account.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.account.arn
  }
}

# HTTP Listener (Redirect to HTTPS)
resource "aws_lb_listener" "account_http_redirect" {
  load_balancer_arn = aws_lb.account.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

####
# STATEMENT ALB LISTENERS (Internal)
####

# HTTPS Listener (Primary)
resource "aws_lb_listener" "statement_https" {
  load_balancer_arn = aws_lb.statement.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn   = aws_acm_certificate_validation.statement.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.statement.arn
  }
}

# HTTP Listener (Redirect to HTTPS)
resource "aws_lb_listener" "statement_http_redirect" {
  load_balancer_arn = aws_lb.statement.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

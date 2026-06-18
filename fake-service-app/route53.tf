data "aws_route53_zone" "main" {
  name         = "hellocloudteam4app.click"
  private_zone = false
}

# Root domain record
resource "aws_route53_record" "customer_profile" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = "hellocloudteam4app.click"
  type    = "A"

  alias {
    name                   = aws_lb.customer_profile.dns_name
    zone_id                = aws_lb.customer_profile.zone_id
    evaluate_target_health = true
  }
}

# Subdomain record
resource "aws_route53_record" "fake_service" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = "fake-service.hellocloudteam4app.click"
  type    = "A"

  alias {
    name                   = aws_lb.customer_profile.dns_name
    zone_id                = aws_lb.customer_profile.zone_id
    evaluate_target_health = true
  }
}

# Record for Account service
resource "aws_route53_record" "account_internal" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = "account.internal.hellocloudteam4app.click"
  type    = "A"

  alias {
    name                   = aws_lb.account.dns_name
    zone_id                = aws_lb.account.zone_id
    evaluate_target_health = true
  }
}

# Record for Statement service
resource "aws_route53_record" "statement_internal" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = "statement.internal.hellocloudteam4app.click"
  type    = "A"

  alias {
    name                   = aws_lb.statement.dns_name
    zone_id                = aws_lb.statement.zone_id
    evaluate_target_health = true
  }
}


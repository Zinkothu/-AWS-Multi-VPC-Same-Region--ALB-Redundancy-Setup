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
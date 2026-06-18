####
# ACM CERTIFICATE FOR CUSTOMER PROFILE (PUBLIC ALB)
####

# Certificate for hellocloudteam4app.click and *.hellocloudteam4app.click
resource "aws_acm_certificate" "customer_profile" {
  domain_name       = "hellocloudteam4app.click"
  validation_method = "DNS"

  subject_alternative_names = [
    "*.hellocloudteam4app.click"
  ]

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "customer-profile-cert"
  }
}

# DNS validation records
resource "aws_route53_record" "customer_profile_cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.customer_profile.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.main.zone_id
}

# Certificate validation
resource "aws_acm_certificate_validation" "customer_profile" {
  certificate_arn         = aws_acm_certificate.customer_profile.arn
  validation_record_fqdns = [for record in aws_route53_record.customer_profile_cert_validation : record.fqdn]
}

####
# ACM CERTIFICATES FOR INTERNAL ALBs (Account & Statement)
# These use self-signed certs or can use ACM private CA
# For simplicity, we'll use ACM with DNS validation
####

# Account Service Certificate (internal)
resource "aws_acm_certificate" "account" {
  domain_name       = "account.internal.hellocloudteam4app.click"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "account-service-cert"
  }
}

resource "aws_route53_record" "account_cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.account.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.main.zone_id
}

resource "aws_acm_certificate_validation" "account" {
  certificate_arn         = aws_acm_certificate.account.arn
  validation_record_fqdns = [for record in aws_route53_record.account_cert_validation : record.fqdn]
}

# Statement Service Certificate (internal)
resource "aws_acm_certificate" "statement" {
  domain_name       = "statement.internal.hellocloudteam4app.click"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "statement-service-cert"
  }
}

resource "aws_route53_record" "statement_cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.statement.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.main.zone_id
}

resource "aws_acm_certificate_validation" "statement" {
  certificate_arn         = aws_acm_certificate.statement.arn
  validation_record_fqdns = [for record in aws_route53_record.statement_cert_validation : record.fqdn]
}

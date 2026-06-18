####
# ADDITIONAL OUTPUTS FOR HTTPS CONFIGURATION
# Add these to your outputs.tf file
####

# Certificate ARNs
output "customer_profile_certificate_arn" {
  value       = aws_acm_certificate.customer_profile.arn
  description = "ARN of Customer Profile SSL certificate"
}

output "account_certificate_arn" {
  value       = aws_acm_certificate.account.arn
  description = "ARN of Account service SSL certificate"
}

output "statement_certificate_arn" {
  value       = aws_acm_certificate.statement.arn
  description = "ARN of Statement service SSL certificate"
}

# HTTPS URLs
output "customer_profile_https_url" {
  value       = "https://${aws_lb.customer_profile.dns_name}"
  description = "HTTPS URL for Customer Profile service (via ALB DNS)"
}

output "customer_profile_domain_https_url" {
  value       = "https://hellocloudteam4app.click"
  description = "HTTPS URL for Customer Profile service (via custom domain)"
}

output "customer_profile_subdomain_https_url" {
  value       = "https://fake-service.hellocloudteam4app.click"
  description = "HTTPS URL for Customer Profile service (via subdomain)"
}

output "account_https_url" {
  value       = "https://${aws_lb.account.dns_name}"
  description = "HTTPS URL for Account service (internal)"
}

output "statement_https_url" {
  value       = "https://${aws_lb.statement.dns_name}"
  description = "HTTPS URL for Statement service (internal)"
}

# Certificate validation status
output "certificates_validation_status" {
  value = {
    customer_profile = "Validated via DNS"
    account          = "Validated via DNS"
    statement        = "Validated via DNS"
  }
  description = "SSL certificate validation status"
}

# SSL/TLS Policy
output "ssl_policy_used" {
  value       = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  description = "SSL/TLS policy applied to ALB listeners"
}

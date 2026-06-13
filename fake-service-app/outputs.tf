output "generated_key_path" {
  value       = local_file.private_key.filename
  description = "Path to the generated private key file (only when Terraform created the key)"
}

output "used_key_name" {
  value       = aws_key_pair.fake_service_app.key_name
  description = "Key pair name used for EC2 instances"
}

output "customer_profile_alb_dns" {
  value = aws_lb.customer_profile.dns_name
}

output "customer_profile_url" {
  value = "http://${aws_lb.customer_profile.dns_name}"
}

output "customer_profile_private_ips" {
  value = [
    aws_instance.customer_profile_app_a.private_ip,
    aws_instance.customer_profile_app_b.private_ip
  ]
}

output "account_alb_dns" {
  value = aws_lb.account.dns_name
}

output "account_private_ips" {
  value = [
    aws_instance.account_app_a.private_ip,
    aws_instance.account_app_b.private_ip
  ]
}

output "statement_alb_dns" {
  value = aws_lb.statement.dns_name
}

output "statement_private_ips" {
  value = [
    aws_instance.statement_app_a.private_ip,
    aws_instance.statement_app_b.private_ip
  ]
}

output "bastion_public_ip" {
  value = aws_instance.bastion.public_ip
}
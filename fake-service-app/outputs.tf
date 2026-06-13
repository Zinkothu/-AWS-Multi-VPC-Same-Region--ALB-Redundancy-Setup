output "generated_key_path" {
  value       = local_file.private_key.filename
  description = "Path to the generated private key file (only when Terraform created the key)"
}

output "used_key_name" {
  value       = aws_key_pair.fake_service_app.key_name
  description = "Key pair name used for EC2 instances"
}


output "customer-profile_public_ip" {
  value = aws_instance.customer-profile_app.public_ip
}

output "customer-profile_url" {
  value = "http://${aws_instance.customer-profile_app.public_ip}:8080"
}

output "account_private_ip" {
  value = aws_instance.account_app.private_ip
}

output "statement_private_ip" {
  value = aws_instance.statement_app.private_ip
}
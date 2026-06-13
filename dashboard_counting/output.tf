output "dashboard_public_ip" {
  value = aws_instance.dashboard-VM.public_ip
}

output "dashboard_url" {
  value = "http://${aws_instance.dashboard-VM.public_ip}:8000"
}

output "counting_private_ip" {
  value = aws_instance.counting-VM.private_ip
}
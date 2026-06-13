resource "aws_instance" "dashboard-VM" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.dashboard_counting_app.key_name
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.dashboard_public.id
  vpc_security_group_ids      = [aws_security_group.dashboard-sg.id]


  # Add this line to run the dashboard script
  user_data = templatefile("scripts/dashboard.sh", {
    counting_ip   = aws_instance.counting-VM.private_ip
    counting_port = "9000"
  })

  depends_on = [aws_instance.counting-VM]

  tags = {
    Name = "dashboard-VM"
  }
}

resource "aws_instance" "counting-VM" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.dashboard_counting_app.key_name
  associate_public_ip_address = false
  subnet_id                   = aws_subnet.counting_private.id
  vpc_security_group_ids      = [aws_security_group.counting-sg.id]


  # Add this line to run the counting script
  user_data = file("scripts/counting.sh")

  tags = {
    Name = "counting-VM"
  }
}

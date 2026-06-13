variable "dashboard_vpc_cidr" {
  description = "CIDR block for Dashboard VPC"
  default     = "10.0.0.0/16"
}

variable "counting_vpc_cidr" {
  description = "CIDR block for Counting VPC"
  default     = "172.16.0.0/16"
}


variable "instance_type" {
  description = "Instance type for EC2 instances"
  default     = "t3.micro"
}
variable "customer-profile_vpc_cidr" {
  description = "CIDR block for Customer Profile VPC"
  default     = "10.0.0.0/16"
}

variable "account_vpc_cidr" {
  description = "CIDR block for Account VPC"
  default     = "172.16.0.0/16"
}

variable "statement_vpc_cidr" {
  description = "CIDR block for Statement VPC"
  default     = "192.168.0.0/16"
}

variable "instance_type" {
  description = "Instance type for EC2 instances"
  default     = "t3.micro"
}

variable "customer_profile_port" {
  description = "Port for Customer Profile service"
  default     = 8080
}

variable "account_port" {
  description = "Port for Account service"
  default     = 8081
}

variable "statement_port" {
  description = "Port for Statement service"
  default     = 8082
}
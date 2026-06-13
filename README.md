# fake-service-app

A Terraform project that provisions a multi-VPC AWS infrastructure simulating a **HelloCloud Bank Retail Banking** microservices architecture. It deploys three interconnected services — **Customer Profile**, **Account**, and **Statement** — across isolated VPCs connected via VPC Peering, with Application Load Balancers and EC2 instances running [nicholasjackson/fake-service](https://github.com/nicholasjackson/fake-service).

---

## Architecture Overview

Internet
│
▼
[customer-profile-vpc] (10.0.0.0/16)
└── Public ALB (port 80) → EC2 x2 (port 9091, private subnets)
│
│ VPC Peering
▼
[account-vpc] (172.16.0.0/16)
└── Internal ALB (port 80) → EC2 x2 (port 9092, private subnets)
│
│ VPC Peering
▼
[statement-vpc] (192.168.0.0/16)
└── Internal ALB (port 80) → EC2 x2 (port 9093, private subnets)


Traffic flows from the internet → Customer Profile ALB → Account ALB → Statement ALB, simulating a chained microservices call pattern.

---

## Infrastructure Components

### VPCs & Networking
VPC	CIDR	Subnets
customer-profile-vpc	10.0.0.0/16	Public (x2), Private (x2)
account-vpc	172.16.0.0/16	Public (x1), Private (x2)
statement-vpc	192.168.0.0/16	Public (x1), Private (x2)
Internet Gateways on all three VPCs
NAT Gateways on account-vpc and statement-vpc for private subnet outbound access
VPC Peering:
customer-profile ↔ account (customer-account-peer)
account ↔ statement (account-statement-peer)
DNS resolution enabled on both peering connections
Load Balancers
ALB	Type	VPC	Listener Port	Target Port
customer-profile-alb	Public (Internet-facing)	customer-profile-vpc	80	9091
account-alb	Internal	account-vpc	80	9092
statement-alb	Internal	statement-vpc	80	9093
EC2 Instances
All instances use Ubuntu 24.04 LTS (Noble) (t3.micro) and run fake-service v0.26.2.

Instance	VPC	Subnet	Port	Upstream
customer-profile-app-a/b	customer-profile-vpc	Private	9091	account-alb
account-app-a/b	account-vpc	Private	9092	statement-alb
statement-app-a/b	statement-vpc	Private	9093	(none)
Security Groups
SG	Inbound	Source
customer-profile-alb-sg	Port 80	0.0.0.0/0
customer-profile-ec2-sg	Port 8080	customer-profile-alb-sg
account-alb-sg	Port 80	10.0.132.80/32, 10.0.145.181/32 (customer-profile EC2s)
account-ec2-sg	Port 8081	account-alb-sg
statement-alb-sg	Port 80	192.168.143.154/32, 192.168.148.114/32 (account EC2s)
statement-ec2-sg	Port 8082	statement-alb-sg

Prerequisites
Terraform >= 1.14
AWS CLI configured with a profile named master-programmatic-admin
AWS region: ap-southeast-1 (Singapore)
An existing key pair or the project will generate one via keypair.tf
File Structure
fake-service-app/
├── versions.tf        # Terraform & provider version constraints
├── variables.tf       # VPC CIDRs, instance type, service ports
├── vpc.tf             # VPCs, subnets, IGWs, route tables
├── vpc-peering.tf     # VPC peering connections & DNS options
├── natgw.tf           # NAT Gateways & EIPs
├── sg.tf              # Security groups
├── alb.tf             # Application Load Balancers, target groups, listeners
├── EC2.tf             # EC2 instances with user_data bootstrapping
├── keypair.tf         # SSH key pair
├── outputs.tf         # Output values (IPs, URLs)
├── scripts/
│   ├── customer-profile.sh   # Bootstraps customer-profile fake-service
│   ├── account.sh            # Bootstraps account fake-service
│   └── statement.sh          # Bootstraps statement fake-service
└── fake-service-app.pem      # SSH private key (do not commit!)
Usage
1. Initialize
terraform init

3. Plan
terraform plan

4. Apply
terraform apply
5. Access the Service
After apply, Terraform outputs the Customer Profile ALB DNS. Test the full chain:

# Test via ALB (public)
curl http://<customer-profile-alb-dns>/

# Test directly (if you have the public IP from outputs)
curl http://<customer_profile_public_ip>:9091
5. SSH into Customer Profile instance


ssh -i fake-service-app.pem ubuntu@<customer_profile_public_ip>
Variables
Variable	Description	Default
customer-profile_vpc_cidr	CIDR for Customer Profile VPC	10.0.0.0/16
account_vpc_cidr	CIDR for Account VPC	172.16.0.0/16
statement_vpc_cidr	CIDR for Statement VPC	192.168.0.0/16
instance_type	EC2 instance type	t3.micro
customer_profile_port	Port for Customer Profile service	9091
account_port	Port for Account service	9092
statement_port	Port for Statement service	9093
Outputs
Output	Description
customer_profile_alb_dns	Public DNS of the Customer Profile ALB
account_private_ip	Private IP of the Account EC2 instance
statement_private_ip	Private IP of the Statement EC2 instance
generated_key_path	Path to the generated SSH private key
used_key_name	AWS key pair name used for EC2 instances
Teardown

terraform destroy
⚠️ This will delete all provisioned resources including VPCs, EC2 instances, NAT Gateways, and EIPs.

Notes
NAT Gateways incur hourly AWS charges even when idle.
The fake-service-app.pem private key should never be committed to version control. Ensure it is listed in .gitignore.
To force re-provisioning of EC2 instances (e.g., after script changes):

terraform taint aws_instance.account_app
terraform taint aws_instance.statement_app
terraform apply
License
This project is for educational/demo purposes simulating a retail banking microservices topology on AWS.


This README covers:
- **Architecture overview** with ASCII diagram matching your `image (1).png`
- **All infrastructure components** (VPCs, ALBs, EC2s, SGs, NAT GWs, VPC Peering)
- **File structure**, **variables**, **outputs**, and **usage instructions**
- Practical notes from your `note.md` (SSH, taint commands, etc.)

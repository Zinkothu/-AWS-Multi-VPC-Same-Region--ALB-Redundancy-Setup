AWS Multi-VPC Banking Microservices Infrastructure
A Terraform project that provisions a banking-style microservices environment on AWS using multiple VPCs, VPC Peering, NAT Gateways, EC2 instances, and service-to-service communication.

The deployment simulates a banking platform with three services:

Customer Profile Service
Account Service
Statement Service
Each service runs on its own EC2 instance and communicates through private networking across VPCs.

Architecture
text
Copy
┌─────────────────────────────┐
│ Customer Profile VPC        │
│ CIDR: 10.0.0.0/16           │
│                             │
│ Public Subnet              │
│ Customer Profile Service   │
└──────────────┬──────────────┘
               │ VPC Peering
               ▼
┌─────────────────────────────┐
│ Account VPC                 │
│ CIDR: 172.16.0.0/16         │
│                             │
│ Private Subnet             │
│ Account Service            │
└──────────────┬──────────────┘
               │ VPC Peering
               ▼
┌─────────────────────────────┐
│ Statement VPC               │
│ CIDR: 192.168.0.0/16        │
│                             │
│ Private Subnet             │
│ Statement Service          │
└─────────────────────────────┘
Service Flow
text
Copy
Customer Profile Service
            │
            ▼
      Account Service
            │
            ▼
     Statement Service
Request chain:

text
Copy
Customer Profile
    ↓
Account
    ↓
Statement
AWS Resources Created
Networking
Customer Profile VPC
Resource	CIDR
VPC	10.0.0.0/16
Public Subnet	10.0.1.0/24
Private Subnet	10.0.2.0/24
Internet Gateway	Yes
Account VPC
Resource	CIDR
VPC	172.16.0.0/16
Public Subnet	172.16.1.0/24
Private Subnet	172.16.2.0/24
Internet Gateway	Yes
NAT Gateway	Yes
Statement VPC
Resource	CIDR
VPC	192.168.0.0/16
Public Subnet	192.168.1.0/24
Private Subnet	192.168.2.0/24
Internet Gateway	Yes
NAT Gateway	Yes
VPC Peering
Customer ↔ Account
Allows communication between:

text
Copy
10.0.0.0/16
172.16.0.0/16
Account ↔ Statement
Allows communication between:

text
Copy
172.16.0.0/16
192.168.0.0/16
DNS resolution across VPCs is enabled.

Compute Resources
Customer Profile Instance
Setting	Value
OS	Ubuntu 24.04
Placement	Public Subnet
Public IP	Yes
Service	customer-profile-service
Account Instance
Setting	Value
OS	Ubuntu 24.04
Placement	Private Subnet
Public IP	No
Service	account-service
Statement Instance
Setting	Value
OS	Ubuntu 24.04
Placement	Private Subnet
Public IP	No
Service	statement-service
Security Groups
Customer Profile
Allowed:

SSH (22) from Internet
HTTP Service (8080) from Internet
HTTP Service (8080) from Account VPC
Account
Allowed:

SSH (22) from Customer VPC
HTTP Service (8080) from Customer VPC
HTTP Service (8080) from Statement VPC
Statement
Allowed:

SSH (22) from Account VPC
HTTP Service (8080) from Account VPC
Fake Service Application
This project uses:

Nicholas Jackson Fake Service

The application is automatically installed during EC2 provisioning using cloud-init scripts.

Customer Profile Service
Forwards requests to:

text
Copy
Account Service
Account Service
Forwards requests to:

text
Copy
Statement Service
Statement Service
Final backend service.

SSH Key Management
Terraform automatically:

Generates RSA private key
Creates AWS Key Pair
Saves private key locally
Generated file:

text
Copy
fake-service-app.pem
Connect:

bash
Copy
ssh -i fake-service-app.pem ubuntu@<customer-public-ip>
Requirements
Terraform
text
Copy
Terraform >= 1.14
Provider
text
Copy
AWS Provider >= 6.37.0
AWS CLI
Configured profile:

text
Copy
master-programmatic-admin
Region:

text
Copy
ap-southeast-1
Deployment
Initialize Terraform
bash
Copy
terraform init
Validate Configuration
bash
Copy
terraform validate
Review Plan
bash
Copy
terraform plan
Deploy Infrastructure
bash
Copy
terraform apply
Testing
Test Customer Profile Service
bash
Copy
curl http://<customer-public-ip>:8080
Test Account Service
From Customer Instance:

bash
Copy
curl http://<account-private-ip>:8080
Test Statement Service
From Account Instance:

bash
Copy
curl http://<statement-private-ip>:8080
Service Management
Customer Profile
bash
Copy
sudo systemctl status customer-profile-api.service

sudo systemctl restart customer-profile-api.service
Account
bash
Copy
sudo systemctl status account-service.service

sudo systemctl restart account-service.service
Statement
bash
Copy
sudo systemctl status statement-service.service

sudo systemctl restart statement-service.service
Rebuild Instances
Force recreation:

bash
Copy
terraform taint aws_instance.customer-profile_app

terraform taint aws_instance.account_app

terraform taint aws_instance.statement_app

terraform apply
File Structure
text
Copy
.
├── versions.tf
├── variables.tf
├── vpc.tf
├── vpc-peering.tf
├── natgw.tf
├── sg.tf
├── keypair.tf
├── EC2.tf
├── scripts/
│   ├── customer-profile.sh
│   ├── account.sh
│   └── statement.sh
└── README.md
Cleanup
Destroy all resources:

bash
Copy
terraform destroy
Important Security Notes
Never commit:

text
Copy
fake-service-app.pem
terraform.tfstate
terraform.tfstate.backup
.terraform/
*.tfvars
Recommended .gitignore:

gitignore
Copy
.terraform/
*.tfstate
*.tfstate.*
.terraform.lock.hcl

*.pem
*.key

*.tfvars
*.tfvars.json

.vscode/
.idea/

*.log
.DS_Store
Author
Terraform AWS Multi-VPC Banking Demo showcasing:

VPC Design
VPC Peering
NAT Gateway Configuration
EC2 Automation
Service Chaining
Infrastructure as Code (IaC) using Terraform
# Development Environment Configuration
environment = "dev"

# VPC & Networking
vpc_name           = "dev-main-vpc"
vpc_cidr_block     = "10.10.0.0/16"
availability_zones = ["us-west-2a", "us-west-2b"]

public_subnet_cidrs   = ["10.10.1.0/24", "10.10.2.0/24"]
private_subnet_cidrs  = ["10.10.11.0/24", "10.10.21.0/24"]
database_subnet_cidrs = ["10.10.12.0/24", "10.10.22.0/24"]

# Compute
client_instance_type = "t3.micro"
server_instance_type = "t3.micro"

# RDS
rds_password = ""

# Environment-specific settings
# cost-effective
single_nat_gateway      = true          
one_nat_gateway_per_az  = false
map_public_ip_on_launch = true
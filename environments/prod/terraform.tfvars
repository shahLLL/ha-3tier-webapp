# Production Environment Configuration
environment = "prod"

# VPC & Networking - different CIDR & more AZs possible
vpc_name           = "prod-main-vpc"
vpc_cidr_block     = "10.20.0.0/16"
availability_zones = ["us-west-2a", "us-west-2b", "us-west-2c"]

public_subnet_cidrs   = ["10.20.1.0/24", "10.20.2.0/24", "10.20.3.0/24"]
private_subnet_cidrs  = ["10.20.11.0/24", "10.20.21.0/24", "10.20.31.0/24"]
database_subnet_cidrs = ["10.20.12.0/24", "10.20.22.0/24", "10.20.32.0/24"]

# Compute - larger instances
client_instance_type = "t3.medium"
server_instance_type = "t3.medium"

# RDS - better resilience
# TODO: use secrets manager
rds_password = ""

# Production hardening
single_nat_gateway      = false
one_nat_gateway_per_az  = true
multi_az                = true
backup_retention_period = 35
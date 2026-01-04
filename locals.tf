locals {
  project_name = var.name
  environment  = var.environment
  region = var.region

  common_tags = {
    Project     = local.project_name
    Environment = local.environment
    ManagedBy   = "Terraform"
    CreatedAt   = timestamp()
  }

  name_prefix = "${local.project_name}-${local.environment}"
  availability_zones = local.environment == "dev" ? ["${local.region}a", "${local.region}b"] : ["${local.region}a", "${local.region}b", "${local.region}c"]
  public_subnet_cidrs = local.environment == "dev" ? ["10.10.1.0/24", "10.10.2.0/24"] : ["10.20.1.0/24", "10.20.2.0/24", "10.20.3.0/24"]
  private_subnet_cidrs = local.environment == "dev" ? ["10.10.11.0/24", "10.10.21.0/24"] : ["10.20.11.0/24", "10.20.21.0/24", "10.20.31.0/24"]
  database_subnet_cidrs = local.environment == "dev" ? ["10.10.12.0/24", "10.10.22.0/24"] : ["10.20.12.0/24", "10.20.22.0/24", "10.20.32.0/24"]
  client_instance_type = local.environment == "dev" ? "t3.micro" : "t3.medium"
  server_instance_type = local.environment == "dev" ? "t3.micro" : "t3.medium"
  single_nat_gateway = local.environment == "dev" ? true : false
  one_nat_gateway_per_az  = local.environment == "dev" ? false : true
  map_public_ip_on_launch = local.environment == "dev" ? true : false
  multi_az = local.environment == "dev" ? false : true
  backup_retention_period = local.environment == "dev" ? 7 : 35
  skip_final_snapshot = local.environment == "dev" ? true : false
}
# Configure AWS Provider
provider "aws" {
    region = "us-west-2"
}

# Create VPC
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 6.5"

  name = var.vpc_name
  cidr = var.vpc_cidr_block

  azs = var.availability_zones

  public_subnets  = var.public_subnet_cidrs
  private_subnets = var.private_subnet_cidrs
  database_subnets = var.database_subnet_cidrs


  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false


  enable_dns_support   = true
  enable_dns_hostnames = true


  map_public_ip_on_launch = true


  create_database_subnet_group = true


  tags = merge(
    local.common_tags,
    {
      Environment = var.environment
      Project     = "3-tier-app"
    }
  )

  public_subnet_tags = {
    Tier = "public"
  }

  private_subnet_tags = {
    Tier = "app"
  }

  database_subnet_tags = {
    Tier = "database"
  }
}

# Security Groups
module "security_groups" {
  source = "./modules/security-groups"

  vpc_id            = module.vpc.vpc_id
  vpc_cidr_block    = module.vpc.vpc_cidr_block
  common_tags       = local.common_tags

  client_sg_name    = "${local.name_prefix}-client-sg"
  server_sg_name    = "${local.name_prefix}-app-sg"
  database_sg_name  = "${local.name_prefix}-db-sg"
}

# Create Load Balancers

# Public Client ALB
module "client_alb" {
  source = "./modules/alb"

  name               = "${local.name_prefix}-client-alb"
  internal           = false
  vpc_id             = module.vpc.vpc_id
  subnets            = module.vpc.public_subnets
  security_group_ids = [module.security_groups.client_sg_id]
  target_port        = 80

  environment = local.environment
  common_tags = local.common_tags
}

# Internal Server ALB
module "server_alb" {
  source = "./modules/alb"

  name               = "${local.name_prefix}-server-alb"
  internal           = true
  vpc_id             = module.vpc.vpc_id
  subnets            = module.vpc.private_subnets
  security_group_ids = [module.security_groups.server_sg_id]
  target_port        = 80

  environment = local.environment
  common_tags = local.common_tags
}

# AWS Key Pair
resource "aws_key_pair" "ec2_key_pair" {
  key_name = "my-key"
  public_key = file("~/.ssh/my-tf-key.pub")
}

# Define EC2 Image
data "aws_ami" "amazon_linux_2" {
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["amazon"]
}

# Create Auto Scaing Groups

# Client ASG
module "client_asg" {
  source = "./modules/asg"

  name_prefix         = "${local.name_prefix}-client"
  vpc_zone_identifier = module.vpc.public_subnets
  ami_id              = data.aws_ami.amazon_linux_2.id
  instance_type       = var.client_instance_type
  security_group_ids  = [module.security_groups.client_sg_id]
  target_group_arns   = [module.client_alb.target_group_arn]
  key_name = aws_key_pair.ec2_key_pair.key_name

  min_size         = 1
  max_size         = 4
  desired_capacity = 2

  health_check_type = "ELB"

  common_tags = local.common_tags
}

# Server ASG
module "server_asg" {
  source = "./modules/asg"

  name_prefix         = "${local.name_prefix}-server"
  vpc_zone_identifier = module.vpc.private_subnets
  ami_id              = data.aws_ami.amazon_linux_2.id
  instance_type       = var.server_instance_type
  security_group_ids  = [module.security_groups.server_sg_id]
  target_group_arns   = [module.server_alb.target_group_arn]
  key_name = aws_key_pair.ec2_key_pair.key_name

  min_size         = 1
  max_size         = 4
  desired_capacity = 2

  health_check_type = "ELB"

  common_tags = local.common_tags
}

# Generate password only if not provided via variable
resource "random_password" "rds_master_password" {
  count = var.rds_password == "" ? 1 : 0

  length           = 16
  special          = true
  override_special = "!@#$%^&*()-_=+"
  min_lower        = 2
  min_upper        = 2
  min_numeric      = 2
  min_special      = 2
}

# Create RDS Instance
module "rds" {
  source = "./modules/rds"

  identifier             = "${local.name_prefix}-mysql"
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro"
  allocated_storage      = 20
  multi_az               = var.environment == "prod" ? true : false
  db_name                = "appdb"
  username               = "admin"
  password               = var.rds_password != "" ? var.rds_password : random_password.rds_master_password[0].result

  db_subnet_group_name   = module.vpc.database_subnet_group_name
  security_group_ids     = [module.security_groups.database_sg_id]

  skip_final_snapshot     = var.environment != "prod"
  backup_retention_period = 7

  environment            = local.environment
  common_tags            = local.common_tags
}

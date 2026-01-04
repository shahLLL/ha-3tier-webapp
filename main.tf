# Configure AWS Provider
provider "aws" {
    region = "us-west-2"
}


# Create VPC
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "6.5.1"

  name = var.vpc_name
  cidr = var.vpc_cidr_block

  azs = [
    var.availability_zone_a,
    var.availability_zone_b,
  ]

  public_subnets = [
    var.subnet_a_cidr_block,
    var.subnet_b_cidr_block,
  ]

  private_subnets = [
    var.subnet_c_cidr_block,
    var.subnet_d_cidr_block,
  ]

  database_subnets = [
    var.subnet_e_cidr_block,
    var.subnet_f_cidr_block,
  ]

  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false

  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Environment = var.client_lb_env
    Terraform   = "true"
    Project     = "3-tier-app"
  }

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


# Create RDS Instance
resource "aws_db_instance" "app_database_free_tier" {
  identifier           = "app-database-free-tier"
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro" 
  allocated_storage    = 20
  storage_type         = "gp2"
  multi_az             = false 

  username             = "appadmin"
  password             = "passwordhaha"
  
  db_subnet_group_name = module.vpc.database_subnet_group_name
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  publicly_accessible  = false 

  backup_retention_period = 0
  skip_final_snapshot     = true
  tags = {
    Name        = "AppDatabaseFreeTier"
    Environment = "DevTest"
  }
}


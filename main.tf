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

# Client Security Group
resource "aws_security_group" "client_sg" {
  name        = var.client_sg_name
  description = "Allow HTTP access from world and SSH access from within VPC"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "Allow HTTP from anywhere (IPv4)"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }

  ingress {
    description = "Allow SSH from within VPC only"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [module.vpc.vpc_cidr_block] 
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # -1 means all protocols
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.client_sg_name
  }
}

# Server Security Group
resource "aws_security_group" "server_sg" {
  name        = var.server_sg_name
  description = "Allow inbound from WebPubSG and outbound to DBPriSG"
  vpc_id      = module.vpc.vpc_id
 
  egress {
    description = "Allow all outbound within VPC"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [module.vpc.vpc_cidr_block]
  }
  
  tags = {
    Name = var.server_sg_name
  }
}

# Database Security Group
resource "aws_security_group" "db_sg" {
  name        = var.db_sg_name
  description = "Database Security Group for MySQL/Aurora"
  vpc_id      = module.vpc.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [module.vpc.vpc_cidr_block]
  }

  tags = {
    Name = var.db_sg_name
  }
}

# Security Group Rules
resource "aws_security_group_rule" "server_sg_ingress_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  description       = "Allow SSH from Client SG"
  security_group_id = aws_security_group.server_sg.id
  source_security_group_id = aws_security_group.client_sg.id
}

resource "aws_security_group_rule" "server_sg_ingress_icmp" {
  type              = "ingress"
  from_port         = 8
  to_port           = 0 # To port 0 for all ICMP types
  protocol          = "icmp"
  description       = "Allow ICMP from Client SG"
  security_group_id = aws_security_group.server_sg.id
  source_security_group_id = aws_security_group.client_sg.id
}

resource "aws_security_group_rule" "db_sg_ingress_mysql" {
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  description       = "Allow DB access from Server SG"
  security_group_id = aws_security_group.db_sg.id
  source_security_group_id = aws_security_group.server_sg.id
}

resource "aws_security_group_rule" "server_sg_egress_db" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  description       = "Allow all traffic outbound to DB"
  security_group_id = aws_security_group.server_sg.id
  source_security_group_id = aws_security_group.db_sg.id
}

# Create Client Application Load Balancer
resource "aws_lb" "client_lb" {
  name = var.client_lb_name
  internal = false
  load_balancer_type = "application"
  subnets = module.vpc.public_subnets
  security_groups = [aws_security_group.client_sg.id]
  enable_deletion_protection = false
  tags = {
    Environment = var.client_lb_env
  }
}

resource "aws_lb_target_group" "clinet_lb_tg" {
  name = var.client_lb_tg_name
  port = 80
  protocol = "HTTP"
  vpc_id = module.vpc.vpc_id

  health_check {
    path = "/"
    protocol = "HTTP"
    matcher = "200"
    interval = 30
    timeout = 5
    healthy_threshold = 3
    unhealthy_threshold = 3
  }
}

resource "aws_lb_listener" "client_lb_listener" {
  load_balancer_arn = aws_lb.client_lb.arn
  port = 80
  protocol = "HTTP"
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.clinet_lb_tg.arn
  }
}

resource "aws_lb" "server_lb" {
  name = var.server_lb_name
  internal = true
  load_balancer_type = "application"
  subnets = module.vpc.public_subnets
  security_groups = [aws_security_group.server_sg.id]
  enable_deletion_protection = false
  tags = {
    Environment = var.server_lb_env
  }
}

resource "aws_lb_target_group" "server_lb_tg" {
  name = var.server_lb_tg_name
  port = 80
  protocol = "HTTP"
  vpc_id = module.vpc.vpc_id

  health_check {
    path = "/"
    protocol = "HTTP"
    matcher = "200"
    interval = 30
    timeout = 5
    healthy_threshold = 3
    unhealthy_threshold = 3
  }
}

resource "aws_lb_listener" "server_lb_listener" {
  load_balancer_arn = aws_lb.server_lb.arn
  port = 80
  protocol = "HTTP"
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.server_lb_tg.arn
  }
}

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


# Create Client EC2 Template
resource "aws_launch_template" "client_template" {
  name_prefix = var.client_ec2_name
  image_id = data.aws_ami.amazon_linux_2.id
  instance_type = var.client_ec2_type
  vpc_security_group_ids = [aws_security_group.client_sg.id]
}

# Create Client EC2 Auto Scaling Group
resource "aws_autoscaling_group" "client_asg" {
  vpc_zone_identifier = module.vpc.public_subnets

  desired_capacity = 2
  max_size = 4
  min_size = 1

  launch_template {
    id = aws_launch_template.client_template.id
    version = "$Latest"
  }
}

# Create Server EC2 Template
resource "aws_launch_template" "server_template" {
  name_prefix = var.server_ec2_name
  image_id = data.aws_ami.amazon_linux_2.id
  instance_type = var.server_ec2_type
  vpc_security_group_ids = [aws_security_group.server_sg.id]
}

# Create Client EC2 Auto Scaling Group
resource "aws_autoscaling_group" "server_asg" {
  vpc_zone_identifier = module.vpc.private_subnets

  desired_capacity = 2
  max_size = 4
  min_size = 1

  launch_template {
    id = aws_launch_template.server_template.id
    version = "$Latest"
  }
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


# Environment
variable "environment" {
    description = "Value of the current environment"
    type = string
    default = "dev"
}

# VPC

variable "vpc_name" {
    description = "Value of the VPC's name tag"
    type = string
    default = "main-vpc"
}

variable "vpc_cidr_block" {
    description = "Value of the VPC's cidr block"
    type = string
    default = "10.0.0.0/16"
}

# AZs

variable "availability_zone_a" {
    description = "Value of the 1st Availability Zone"
    type = string
    default = "us-west-2a"
}

variable "availability_zone_b" {
    description = "Value of the 2nd Availability Zone"
    type = string
    default = "us-west-2b"
}

# Subnets

# Subnet A is the first client subnet
variable "subnet_a_name" {
    description = "Value of Subnet A's name tag"
    type = string
    default = "client-subnet-a"
}

variable "subnet_a_cidr_block" {
    description = "Value of the Subnet A's cidr block"
    type = string
    default = "10.0.1.0/24"
}

# Subnet B is the first client subnet
variable "subnet_b_name" {
    description = "Value of Subnet B's name tag"
    type = string
    default = "client-subnet-b"
}

variable "subnet_b_cidr_block" {
    description = "Value of the Subnet B's cidr block"
    type = string
    default = "10.0.2.0/24"
}

# Subnet C is the first server subnet
variable "subnet_c_name" {
    description = "Value of Subnet C's name tag"
    type = string
    default = "server-subnet-a"
}

variable "subnet_c_cidr_block" {
    description = "Value of the Subnet C's cidr block"
    type = string
    default = "10.0.11.0/24"
}

# Subnet D is the second server subnet
variable "subnet_d_name" {
    description = "Value of Subnet D's name tag"
    type = string
    default = "server-subnet-b"
}

variable "subnet_d_cidr_block" {
    description = "Value of the Subnet D's cidr block"
    type = string
    default = "10.0.21.0/24"
}

# Subnet E is the first database subnet
variable "subnet_e_name" {
    description = "Value of Subnet E's name tag"
    type = string
    default = "db-subnet-a"
}

variable "subnet_e_cidr_block" {
    description = "Value of the Subnet E's cidr block"
    type = string
    default = "10.0.12.0/24"
}

# Subnet F is the first database subnet
variable "subnet_f_name" {
    description = "Value of Subnet F's name tag"
    type = string
    default = "db-subnet-b"
}

variable "subnet_f_cidr_block" {
    description = "Value of the Subnet F's cidr block"
    type = string
    default = "10.0.22.0/24"
}

# IGW
variable "igw_name" {
    description = "Value of the Intenet Gateway's name tag"
    type = string
    default = "main-igw"
}

# NAT Gateway
variable "eip_name" {
    description = "Value of the NAT Gateway's ELastic IP's name tag"
    type = string
    default = "natgw-ip"
}

variable "natgw_name" {
    description = "Value of the NAT Gateway's name tag"
    type = string
    default = "main-nat-gateway"
}

# Client Route Table
variable "client_rt_name" {
    description = "Value of the Client Route Table's name tag"
    type = string
    default = "client-route-table"
}

variable "client_rt_cidr" {
    description = "Value of the Client Route Table's CIDR Block"
    type = string
    default = "0.0.0.0/0"
}

# Server Route Table
variable "server_rt_name" {
    description = "Value of the Server Route Table's name tag"
    type = string
    default = "server-route-table"
}

variable "server_rt_cidr" {
    description = "Value of the Server Route Table's CIDR Block"
    type = string
    default = "0.0.0.0/0"
}

# Database Route Table
variable "database_rt_name" {
    description = "Value of the Database Route Table's name tag"
    type = string
    default = "database-route-table"
}

# Client Security Group
variable "client_sg_name" {
    description = "Value of the Client Security Group's name tag"
    type = string
    default = "client-security-group"
}

variable "client_instance_type" {
    description = "Client EC2 instance type"
    type = string
    default = "t3.micro"
}

# Server Security Group
variable "server_sg_name" {
    description = "Value of the Server Security Group's name tag"
    type = string
    default = "server-security-group"
}

variable "server_instance_type" {
    description = "Server EC2 instance type"
    type = string
    default = "t3.micro"
}

# Database Security Group
variable "db_sg_name" {
    description = "Value of the Database Security Group's name tag"
    type = string
    default = "db-security-group"
}

# Client Load Balancer
variable "client_lb_name" {
    description = "Value of the name field in the client load balancer"
    type = string
    default = "client-load-balancer"
}

variable "client_lb_env" {
    description = "Value of the Environment field in the client load balancer"
    type = string
    default = "dev"
}

variable "client_lb_tg_name" {
    description = "Value of the name field in the client target group"
    type = string
    default = "client-target-group"
}

# Server Load Balancer
variable "server_lb_name" {
    description = "Value of the name field in the server load balancer"
    type = string
    default = "server-load-balancer"
}

variable "server_lb_env" {
    description = "Value of the Environment field in the server load balancer"
    type = string
    default = "dev"
}

variable "server_lb_tg_name" {
    description = "Value of the name field in the server target group"
    type = string
    default = "server-target-group"
}

# Client EC2
variable "client_ec2_name" {
    description = "Value of the name field in the client EC2 launch template"
    type = string
    default = "client-ec2"
}

variable "client_ec2_type" {
    description = "Value of the type field in the client EC2 launch template"
    type = string
    default = "t3.micro"
}

# Server EC2
variable "server_ec2_name" {
    description = "Value of the name field in the server EC2 launch template"
    type = string
    default = "server-ec2"
}

variable "server_ec2_type" {
    description = "Value of the type field in the server EC2 launch template"
    type = string
    default = "t3.micro"
}

# DB Subnet Group
variable "db_subnet_grp_name" {
    description = "Value of the Name field in the DB Subnet Group"
    type = string
    default = "Database-Subnet-Group"
}

variable "rds_password" {
  description = "Master password for the RDS instance. Leave empty to auto-generate a random password."
  type        = string
  sensitive   = true
}
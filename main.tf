# Configure AWS Provider
provider "aws" {
    region = "us-west-2"
}

# Create VPC
resource "aws_vpc" "main"{
    cidr_block = var.vpc_cidr_block
    enable_dns_support = true
    enable_dns_hostnames = true
    tags = {
        Name = var.vpc_name
    }
}

# Create 1st Client Subnet
resource "aws_subnet" "subnet_a" {
    vpc_id = aws_vpc.main.id
    cidr_block = var.subnet_a_cidr_block
    availability_zone = var.availability_zone_a
    map_public_ip_on_launch = true

    tags = {
        Name = var.subnet_a_name
    }
}

# Create 2nd Client Subnet
resource "aws_subnet" "subnet_b" {
    vpc_id = aws_vpc.main.id
    cidr_block = var.subnet_b_cidr_block
    availability_zone = var.availability_zone_b
    map_public_ip_on_launch = true

    tags = {
        Name = var.subnet_b_name
    }
}

# Create 1st Server Subnet
resource "aws_subnet" "subnet_c" {
    vpc_id = aws_vpc.main.id
    cidr_block = var.subnet_c_cidr_block
    availability_zone = var.availability_zone_a
    map_public_ip_on_launch = false

    tags = {
        Name = var.subnet_c_name
    }
}

# Create 2nd Server Subnet
resource "aws_subnet" "subnet_d" {
    vpc_id = aws_vpc.main.id
    cidr_block = var.subnet_d_cidr_block
    availability_zone = var.availability_zone_b
    map_public_ip_on_launch = true

    tags = {
        Name = var.subnet_d_name
    }
}

# Create 1st Database Subnet
resource "aws_subnet" "subnet_e" {
    vpc_id = aws_vpc.main.id
    cidr_block = var.subnet_e_cidr_block
    availability_zone = var.availability_zone_a
    map_public_ip_on_launch = false

    tags = {
        Name = var.subnet_e_name
    }
}

# Create 2nd Database Subnet
resource "aws_subnet" "subnet_f" {
    vpc_id = aws_vpc.main.id
    cidr_block = var.subnet_f_cidr_block
    availability_zone = var.availability_zone_b
    map_public_ip_on_launch = true

    tags = {
        Name = var.subnet_f_name
    }
}

# Create Internet Gateway
resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.main.id
    tags = {
        Name = var.igw_name
    }
}

# Create Elastic IP for NAT Gateway
resource "aws_eip" "nat_gw_ip" {
    tags = {
        Name = var.eip_name
    }
}

# Create NAT Gateway
resource "aws_nat_gaetway" "nat_gw" {
    subnet_id = aws_subnet.subnet_a.id
    allocation_id = aws_eip.nat_gw_ip.id
    tags = {
        Name = var.natgw_name
    }
}

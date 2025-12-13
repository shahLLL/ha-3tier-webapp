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
resource "aws_nat_gateway" "nat_gw" {
    subnet_id = aws_subnet.subnet_a.id
    allocation_id = aws_eip.nat_gw_ip.id
    tags = {
        Name = var.natgw_name
    }
}

# Create Route Table for Client Layer
resource "aws_route_table" "client_rt" {
    vpc_id = aws_vpc.main.id
    route {
        cidr_block = var.client_rt_cidr
        gateway_id = aws_internet_gateway.igw.id
    }
    tags = {
        Name = var.client_rt_name
    }
}

# Create Route Table for Server Layer
resource "aws_route_table" "server_rt" {
    vpc_id = aws_vpc.main.id
    route {
        cidr_block = var.server_rt_cidr
        gateway_id = aws_nat_gateway.nat_gw.id
    }
    tags = {
        Name = var.server_rt_name
    }
}

# Create Route Table for Database Layer
resource "aws_route_table" "database_rt" {
    vpc_id = aws_vpc.main.id
    tags = {
        Name = var.database_rt_name
    }
}

# Complete Route Table and Subnet Associations
resource "aws_route_table_association" "client_a_assoc" {
  subnet_id      = aws_subnet.subnet_a.id
  route_table_id = aws_route_table.client_rt.id
}

resource "aws_route_table_association" "client_b_assoc" {
  subnet_id      = aws_subnet.subnet_b.id
  route_table_id = aws_route_table.client_rt.id
}

resource "aws_route_table_association" "server_a_assoc" {
  subnet_id      = aws_subnet.subnet_c.id
  route_table_id = aws_route_table.server_rt.id
}

resource "aws_route_table_association" "server_b_assoc" {
  subnet_id      = aws_subnet.subnet_d.id
  route_table_id = aws_route_table.server_rt.id
}

resource "aws_route_table_association" "database_a_assoc" {
  subnet_id      = aws_subnet.subnet_e.id
  route_table_id = aws_route_table.database_rt.id
}

resource "aws_route_table_association" "public_a_assoc" {
  subnet_id      = aws_subnet.subnet_f.id
  route_table_id = aws_route_table.database_rt.id
}

# Client Security Group
resource "aws_security_group" "client_sg" {
  name        = var.client_sg_name
  description = "Allow HTTP access from world and SSH access from within VPC"
  vpc_id      = aws_vpc.main.id

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
    cidr_blocks = [aws_vpc.main.cidr_block] 
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
  vpc_id      = aws_vpc.main.id
 
  egress {
    description = "Allow all outbound within VPC"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [aws_vpc.main.cidr_block]
  }
  
  tags = {
    Name = var.server_sg_name
  }
}

# Database Security Group
resource "aws_security_group" "db_sg" {
  name        = var.db_sg_name
  description = "Database Security Group for MySQL/Aurora"
  vpc_id      = aws_vpc.main.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [aws_vpc.main.cidr_block]
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


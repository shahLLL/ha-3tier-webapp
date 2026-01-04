# 1. Public/Client Security Group (for public-facing instances / ALB ingress)
resource "aws_security_group" "client" {
  name        = var.client_sg_name
  description = "Security group for public/client tier - HTTP/HTTPS from internet, SSH limited"
  vpc_id      = var.vpc_id

  # HTTP
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTP from anywhere"
  }

  # HTTPS
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTPS from anywhere"
  }

  # SSH - restrict to VPC CIDR
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr_block]
    description = "SSH from within VPC"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.common_tags,
    {
      Name = var.client_sg_name
      Tier = "public"
    }
  )
}

# 2. Application/Server Security Group (private tier)
resource "aws_security_group" "server" {
  name        = var.server_sg_name
  description = "Security group for application/server tier"
  vpc_id      = var.vpc_id

  # Allow HTTP/HTTPS from the client/public security group (ALB or instances)
  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.client.id]
    description     = "HTTP from client/public tier"
  }

  # HTTPS
  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.client.id]
  }

  # SSH from client tier (for debugging)
  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.client.id]
    description     = "SSH from client tier (debug)"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.common_tags,
    {
      Name = var.server_sg_name
      Tier = "app"
    }
  )
}

# 3. Database Security Group (most restricted)
resource "aws_security_group" "database" {
  name        = var.database_sg_name
  description = "Security group for database tier - only from application layer"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.server.id]
    description     = "MySQL from application tier only"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.common_tags,
    {
      Name = var.database_sg_name
      Tier = "database"
    }
  )
}
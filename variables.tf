# ── Environment & Naming ───────────────────────────────────────────────────────

variable "environment" {
  description = "Deployment environment (dev/staging/prod)"
  type        = string
  default     = "dev"
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be one of: dev, staging, prod."
  }
}

# ── VPC & Networking ───────────────────────────────────────────────────────────

variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
  default     = "main-vpc"
}

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "List of availability zones to use"
  type        = list(string)
  default     = ["us-west-2a", "us-west-2b"]
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public (client) subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private (application) subnets"
  type        = list(string)
  default     = ["10.0.11.0/24", "10.0.21.0/24"]
}

variable "database_subnet_cidrs" {
  description = "CIDR blocks for database subnets"
  type        = list(string)
  default     = ["10.0.12.0/24", "10.0.22.0/24"]
}

# ── Compute ────────────────────────────────────────────────────────────────────

variable "client_instance_type" {
  description = "Instance type for client/public tier"
  type        = string
  default     = "t3.micro"
}

variable "server_instance_type" {
  description = "Instance type for application/private tier"
  type        = string
  default     = "t3.micro"
}

# ── RDS ────────────────────────────────────────────────────────────────────────

variable "rds_password" {
  description = "Master password for RDS. Leave empty to auto-generate a random password."
  type        = string
  sensitive   = true
  # no default → forces explicit decision in production
}

# ── KEY ────────────────────────────────────────────────────────

variable "key_name" {
  description = "Name of existing EC2 key pair for SSH access (optional)"
  type        = string
  default     = null
}

# ── NAT ────────────────────────────────────────────────────────

variable "single_nat_gateway" {
  description = "Whether to use a single NAT Gateway (cost-saving for dev)"
  type        = bool
  default     = true
}

variable "one_nat_gateway_per_az" {
  description = "Create one NAT Gateway per AZ (better HA for prod)"
  type        = bool
  default     = false
}

variable "map_public_ip_on_launch" {
  description = "Auto-assign public IP in public subnets"
  type        = bool
  default     = true
}
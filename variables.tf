# ── Environment & Naming ───────────────────────────────────────────────────────

variable "environment" {
  description = "Deployment environment (dev/staging/prod)"
  type        = string
  default     = "dev"
  validation {
    condition     = contains(["dev", "prod"], var.environment)
    error_message = "Environment must be one of: dev, staging, prod."
  }
}

variable "name" {
  description = "Project Name"
  type        = string
  default     = "3tier-app"
}

# ── Region ───────────────────────────────────────────────────────
variable "region" {
  description = "Region"
  type        = string
  default     = "us-west-2"
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

# ── KEY ───────────────────────────────────────────────────────────

variable "key_name" {
  description = "AWS Key Name"
  type        = string
}

variable "key_path" {
  description = "AWS Key File Path"
  type        = string
}

# ── RDS ────────────────────────────────────────────────────────────────────────

variable "rds_password" {
  description = "Master password for RDS. Leave empty to auto-generate a random password."
  type        = string
  sensitive   = true
  # no default → forces explicit decision in production
}

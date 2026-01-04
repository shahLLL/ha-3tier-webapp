variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "vpc_cidr_block" {
  description = "CIDR block of the VPC (used for intra-VPC access rules)"
  type        = string
}

variable "client_sg_name" {
  description = "Name for the client/public security group"
  type        = string
}

variable "server_sg_name" {
  description = "Name for the application/server security group"
  type        = string
}

variable "database_sg_name" {
  description = "Name for the database security group"
  type        = string
}

variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default     = {}
}
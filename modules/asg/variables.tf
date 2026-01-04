variable "name_prefix" {
  description = "Prefix for names (e.g. 'dev-client', 'prod-server')"
  type        = string
}

variable "vpc_zone_identifier" {
  description = "List of subnet IDs where instances will be launched"
  type        = list(string)
}

variable "ami_id" {
  description = "AMI ID to use for instances"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "security_group_ids" {
  description = "List of security group IDs for instances"
  type        = list(string)
}

variable "key_name" {
  description = "Name of EC2 key pair for SSH access (optional)"
  type        = string
}

variable "min_size" {
  description = "Minimum number of instances"
  type        = number
  default     = 1
}

variable "max_size" {
  description = "Maximum number of instances"
  type        = number
  default     = 4
}

variable "desired_capacity" {
  description = "Desired number of instances"
  type        = number
  default     = 2
}

variable "health_check_type" {
  description = "Health check type ('EC2' or 'ELB')"
  type        = string
  default     = "ELB"
}

variable "health_check_grace_period" {
  description = "Grace period for health checks in seconds"
  type        = number
  default     = 300
}

variable "target_group_arns" {
  description = "List of target group ARNs to attach instances to"
  type        = list(string)
  default     = []
}

variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default     = {}
}
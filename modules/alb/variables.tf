variable "name" {
  description = "Name of the load balancer (e.g. client-alb, server-alb)"
  type        = string
}

variable "internal" {
  description = "Whether the LB is internal (true) or internet-facing (false)"
  type        = bool
  default     = false
}

variable "vpc_id" {
  description = "VPC ID where the LB will be created"
  type        = string
}

variable "subnets" {
  description = "List of subnet IDs for the LB"
  type        = list(string)
}

variable "security_group_ids" {
  description = "List of security group IDs for the LB"
  type        = list(string)
}

variable "target_port" {
  description = "Port on which the target instances listen"
  type        = number
  default     = 80
}

variable "health_check_path" {
  description = "Path for health checks"
  type        = string
  default     = "/"
}

variable "health_check_matcher" {
  description = "HTTP status codes considered healthy"
  type        = string
  default     = "200"
}

variable "health_check_interval" {
  description = "Health check interval in seconds"
  type        = number
  default     = 30
}

variable "health_check_timeout" {
  description = "Health check timeout in seconds"
  type        = number
  default     = 5
}

variable "health_check_healthy_threshold" {
  description = "Consecutive successes before healthy"
  type        = number
  default     = 3
}

variable "health_check_unhealthy_threshold" {
  description = "Consecutive failures before unhealthy"
  type        = number
  default     = 3
}

variable "enable_deletion_protection" {
  description = "Prevent accidental deletion of the LB"
  type        = bool
  default     = false
}

variable "environment" {
  description = "Environment name (dev/staging/prod)"
  type        = string
}

variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default     = {}
}

# Optional: for HTTPS
variable "certificate_arn" {
  description = "ACM certificate ARN for HTTPS listener"
  type        = string
  default     = null
}
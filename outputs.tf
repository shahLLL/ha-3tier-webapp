output "vpc_id" {
  description = "ID of the created VPC"
  value       = module.vpc.vpc_id
}

output "public_subnets" {
  description = "IDs of public (client) subnets"
  value       = module.vpc.public_subnets
}

output "private_subnets" {
  description = "IDs of private (application) subnets"
  value       = module.vpc.private_subnets
}

output "database_subnets" {
  description = "IDs of database subnets"
  value       = module.vpc.database_subnets
}

output "client_alb_dns_name" {
  description = "DNS name of the public client Application Load Balancer"
  value       = module.client_alb.dns_name
}

output "server_alb_dns_name" {
  description = "DNS name of the internal server Application Load Balancer"
  value       = module.server_alb.dns_name
}

output "rds_endpoint" {
  description = "Connection endpoint for the RDS instance"
  value       = module.rds.rds_endpoint
  sensitive   = true
}

output "rds_address" {
  description = "Hostname/address of the RDS instance"
  value       = module.rds.rds_address
  sensitive   = true
}

output "rds_master_password" {
  description = "Master password for RDS (only populated if auto-generated)"
  value       = var.rds_password != "" ? null : try(module.rds.master_password, null)
  sensitive   = true
}

output "client_asg_name" {
  description = "Name of the client/public Auto Scaling Group"
  value       = module.client_asg.asg_name
}

output "server_asg_name" {
  description = "Name of the server/private Auto Scaling Group"
  value       = module.server_asg.asg_name
}

output "environment" {
  description = "Current deployment environment"
  value       = var.environment
}
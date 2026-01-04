output "rds_endpoint" {
  description = "The endpoint of the RDS instance"
  value       = aws_db_instance.rds_instance.endpoint
  sensitive   = true
}

output "rds_address" {
  description = "The address of the RDS instance"
  value       = aws_db_instance.rds_instance.address
}

output "rds_arn" {
  description = "ARN of the RDS instance"
  value       = aws_db_instance.rds_instance.arn
}

output "master_password" {
  description = "Generated master password (if not provided)"
  value       = var.password
  sensitive   = true
}

output "instance_id" {
  description = "ID of the RDS instance"
  value       = aws_db_instance.rds_instance.id
}
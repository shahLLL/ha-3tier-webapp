output "rds_endpoint" {
  description = "The endpoint of the RDS instance"
  value       = aws_db_instance.this.endpoint
  sensitive   = true
}

output "rds_address" {
  description = "The address of the RDS instance"
  value       = aws_db_instance.this.address
}

output "rds_arn" {
  description = "ARN of the RDS instance"
  value       = aws_db_instance.this.arn
}

output "master_password" {
  description = "Generated master password (if not provided)"
  value       = var.password == "" ? random_password.master_password[0].result : null
  sensitive   = true
}

output "instance_id" {
  description = "ID of the RDS instance"
  value       = aws_db_instance.this.id
}
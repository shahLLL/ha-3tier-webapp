output "client_sg_id" {
  description = "ID of the client/public security group"
  value       = aws_security_group.client.id
}

output "server_sg_id" {
  description = "ID of the application/server security group"
  value       = aws_security_group.server.id
}

output "database_sg_id" {
  description = "ID of the database security group"
  value       = aws_security_group.database.id
}

# Optional: export the full security group objects if needed
output "client_sg" {
  description = "Full client security group object"
  value       = aws_security_group.client
}

output "server_sg" {
  description = "Full server security group object"
  value       = aws_security_group.server
}

output "database_sg" {
  description = "Full database security group object"
  value       = aws_security_group.database
}
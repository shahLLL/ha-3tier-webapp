# RDS Instance
resource "aws_db_instance" "rds_instance" {
  identifier           = var.identifier
  engine               = var.engine
  engine_version       = var.engine_version
  instance_class       = var.instance_class
  allocated_storage    = var.allocated_storage
  storage_type         = var.storage_type
  multi_az             = var.multi_az

  db_name              = var.db_name
  username             = var.username
  password             = var.password

  vpc_security_group_ids = var.security_group_ids
  db_subnet_group_name   = var.db_subnet_group_name

  publicly_accessible  = false
  skip_final_snapshot  = var.skip_final_snapshot
  final_snapshot_identifier = var.skip_final_snapshot ? null : "${var.identifier}-final-snapshot"

  backup_retention_period = var.backup_retention_period
  backup_window           = var.backup_window
  maintenance_window      = var.maintenance_window

  performance_insights_enabled = var.performance_insights_enabled

  tags = merge(
    var.common_tags,
    {
      Name        = var.identifier
      Environment = var.environment
    }
  )
}
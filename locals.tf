locals {
  project_name = "3tier-app"
  environment  = var.environment  # dev/staging/prod

  common_tags = {
    Project     = local.project_name
    Environment = local.environment
    ManagedBy   = "Terraform"
    CreatedAt   = timestamp()
  }

  name_prefix = "${local.project_name}-${local.environment}"
}
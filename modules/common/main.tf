locals {
  common_tags = {
    Project     = var.project
    Environment = var.environment
    Name        = var.resource_name
    Entity      = var.entity
    ManagedBy   = "Terraform"
  }
}

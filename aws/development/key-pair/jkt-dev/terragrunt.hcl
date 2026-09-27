terraform {
  source = "../../../../modules/aws/key-pair"
}

include {
  path = find_in_parent_folders("tfvars.hcl")
}

locals {
  resource_name = basename(get_terragrunt_dir())
}

inputs = {
  name = local.resource_name

  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILSGC2lNo/5QRfIbZ7BfUarrAwN6W0su36CU8yfHG40s jkt-dev-labs"

  common_tags = {
    Project     = "infra-terraform-labs"
    Environment = "development"
    ManagedBy   = "Terraform"
    Owner       = "rafi"
  }
}
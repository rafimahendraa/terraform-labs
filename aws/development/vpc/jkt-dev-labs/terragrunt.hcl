terraform {
  source = "../../../../modules/aws/vpc"
}

include {
  path = find_in_parent_folders("tfvars.hcl")
}

locals {
  resource_name = basename(get_terragrunt_dir())
}

inputs = {
  name = local.resource_name

  vpc_cidr = "10.0.0.0/16"

  availability_zones = [
    "us-east-1a",
    "us-east-1b"
  ]

  public_subnet_cidrs = [
    "10.0.1.0/24",
    "10.0.2.0/24"
  ]

  private_subnet_cidrs = [
    "10.0.11.0/24",
    "10.0.12.0/24"
  ]

  nat_gateway_mode = "single"

  common_tags = {
    Project     = "infra-terraform-labs"
    Environment = "development"
    ManagedBy   = "Terraform"
    Owner       = "rafi"
  }
}

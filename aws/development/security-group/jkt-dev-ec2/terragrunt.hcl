terraform {
  source = "../../../../modules/aws/security-group"
}

include {
  path = find_in_parent_folders("tfvars.hcl")
}

locals {
  resource_name = basename(get_terragrunt_dir())
}

dependency "vpc" {
  config_path = "../../vpc/jkt-dev-labs"
}

inputs = {
  name        = local.resource_name
  description = "Security group for development EC2"

  vpc_id = dependency.vpc.outputs.vpc_id

  ingress_rules = [
    {
      description = "SSH"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  egress_rules = [
    {
      description = "Allow all outbound"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  common_tags = {
    Project     = "infra-terraform-labs"
    Environment = "development"
    ManagedBy   = "Terraform"
    Owner       = "rafi"
  }
}

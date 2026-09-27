terraform {
  source = "../../../../modules/aws/ec2"
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

dependency "security_group" {
  config_path = "../../security-group/jkt-dev-ec2"
}

dependency "key_pair" {
  config_path = "../../key-pair/jkt-dev"
}

inputs = {
  name = local.resource_name

  ami           = "ami-ubuntu2404-amd64"
  instance_type = "t3.micro"

  subnet_id = dependency.vpc.outputs.private_subnet_ids["us-east-1a"]

  security_group_ids = [
    dependency.security_group.outputs.security_group_id
  ]

  key_name = dependency.key_pair.outputs.key_pair_name

  associate_public_ip_address = false

  common_tags = {
    Project     = "infra-terraform-labs"
    Environment = "development"
    ManagedBy   = "Terraform"
    Owner       = "rafi"
  }
}

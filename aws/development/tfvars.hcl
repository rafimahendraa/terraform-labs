locals {
  region  = "us-east-1"
  entity  = "rafi"
  profile = "default"
}

remote_state {
  backend = "s3"

  generate = {
    path      = "backend.tf"
    if_exists = "overwrite"
  }

  config = {
    region  = local.region
    profile = local.profile
    bucket  = "infra-terraform-labs-state"
    encrypt = true
    key     = "${local.entity}/${local.profile}/${path_relative_to_include()}/terraform.tfstate"
  }
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite"

  contents = <<EOF
provider "aws" {
  region  = "${local.region}"
  profile = "${local.profile}"
}
EOF
}

inputs = {
  project     = "infra-terraform-labs"
  environment = "development"
  entity      = local.entity

  aws_region  = local.region
  aws_profile = local.profile
}

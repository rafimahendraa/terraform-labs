provider "aws" {
  region = var.aws_region

  access_key = "test"
  secret_key = "test"

  endpoints {
    ec2 = "http://localhost.floci.io:4566"
  }
  # Endpoint Floci akan kita konfigurasi di sini
}

module "network" {
  source = "../../modules/aws/network"

  name                = var.environment
  vpc_cidr            = var.vpc_cidr
  public_subnet_cidr  = var.public_subnet_cidr
  private_subnet_cidr = var.private_subnet_cidr
  availability_zone   = var.availability_zone
}

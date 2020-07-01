locals {
  cidr_block = "192.168.0.0/16"
}

module "vpc" {
  source = "../.."

  module_enabled = var.module_enabled

  vpc_name         = "test"
  cidr_block       = local.cidr_block
  nat_gateway_mode = var.nat_gateway_mode

  subnets = [
    {
      group = "test"
      class = "public"

      netnums_by_az = {
        a = [0]
        b = [1]
      }
    },
    {
      group = "test"
      class = "private"

      netnums_by_az = {
        a = [2]
        b = [3]
      }
    },
    {
      group = "test"
      class = "intra"

      netnums_by_az = {
        a = [128]
        b = [129]
      }
    },
  ]
}

provider "aws" {
  region  = var.aws_region
  version = "~> 2.0"
}

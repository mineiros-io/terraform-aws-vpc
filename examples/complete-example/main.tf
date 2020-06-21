# ---------------------------------------------------------------------------------------------------------------------
# CREATE AN EXAMPLE VPC WITH SUBNETS, INTERNET- AND NAT GATEWAYS
# ---------------------------------------------------------------------------------------------------------------------

locals {
  cidr_block = "10.0.0.0/16"
}

module "vpc" {
  source = "../.."

  module_enabled = true

  vpc_name   = "main"
  cidr_block = local.cidr_block
  # nat_gateway_mode = "one_per_az" # (defaults to "single")
  # nat_gateway_mode = "none" # (defaults to "single")

  subnets = [
    {
      group = "main"   # (default: default)
      class = "public" # (default: private)

      map_public_ip_on_launch         = true
      assign_ipv6_address_on_creation = false

      cidr_block = cidrsubnet(local.cidr_block, 4, 0) # (default: cidr_block of vpc)
      newbits    = 4                                  # (default: 8)
      netnums_by_az = {
        a = [0]
        b = [1]
      }
      routes = [
      ]
      tags = {
      }
    },
    {
      group = "main"
      class = "private" # (default: private)

      cidr_block = cidrsubnet(local.cidr_block, 4, 1) # (default: cidr_block of vpc)
      newbits    = 4                                  # (default: 8)
      netnums_by_az = {
        a = [0]
        b = [1]
        c = [2]
      }
    },
    {
      group = "database"
      class = "intra" # (default: private)

      map_public_ip_on_launch         = true
      assign_ipv6_address_on_creation = false

      cidr_block = cidrsubnet(local.cidr_block, 4, 2) # (default: cidr_block of vpc)
      newbits    = 4                                  # (default: 8)
      netnums_by_az = {
        a = [0]
        b = [1]
      }
      routes = [
      ]
      tags = {
      }
    },
  ]
}

provider "aws" {
  region  = var.aws_region
  version = "~> 2.0"
}

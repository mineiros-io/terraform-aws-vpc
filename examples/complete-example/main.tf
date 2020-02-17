# ---------------------------------------------------------------------------------------------------------------------
# CREATE AN EXAMPLE VPC WITH SUBNETS, INTERNET- AND NAT GATEWAYS
# ---------------------------------------------------------------------------------------------------------------------

provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source = "../.."

  create = true

  vpc_name            = "Test"
  cidr_block          = "10.0.0.0/16"
  create_nat_gateways = "one_per_az"

  public_subnets = [
    {
      availability_zone = "us-east-1a",
      cidr_block        = "10.0.64.0/21",
    },
    {
      availability_zone = "us-east-1a",
      cidr_block        = "10.0.80.0/21",
    },
    {
      availability_zone = "us-east-1b",
      cidr_block        = "10.0.96.0/21",
    }
  ]

  private_subnets = [
    {
      availability_zone = "us-east-1a",
      cidr_block        = "10.0.112.0/21",
    },
    {
      availability_zone = "us-east-1b",
      cidr_block        = "10.0.128.0/21",
    },
    {
      availability_zone = "us-east-1c",
      cidr_block        = "10.0.144.0/21",
    }
  ]

  intra_subnets = [
    {
      availability_zone = "us-east-1a",
      cidr_block        = "10.0.160.0/21",
    },
    {
      availability_zone = "us-east-1b",
      cidr_block        = "10.0.176.0/21",
    }
  ]

  tags = {
    "Bob" = "Alice"
  }
}

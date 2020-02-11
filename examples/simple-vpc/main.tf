module "vpc" {
  source = "../.."
  create = true

  vpc_name = "Test"

  cidr_block = "10.0.0.0/16"

  enable_nat_gateway     = true
  create_single_nat_only = false

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

  private_persistence_subnets = [
    {
      availability_zone = "us-east-1a",
      cidr_block        = "10.0.144.0/21",
    },
    {
      availability_zone = "us-east-1b",
      cidr_block        = "10.0.160.0/21",
    }
  ]

  tags = {
    "Bob" = "Alice"
  }
}

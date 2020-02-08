module "vpc" {
  source   = "../.."
  vpc_name = "Test"

  cidr_block = "10.0.0.0/16"

  public_subnets = {
    "10.0.64.0/21" = "us-east-1a",
    "10.0.80.0/21" = "us-east-1a",
    "10.0.96.0/21" = "us-east-1b"
  }

  //  public_subnets = {
  //    "10.0.64.0/21" = {
  //      az                 = "us-east-1a",
  //      enable_nat_gateway = true,
  //      custom_nat_eip     = "17.245.21.16"
  //    }
  //    "10.0.96.0/21" = {
  //      az                 = "us-east-1b",
  //      enable_nat_gateway = false
  //    }
  //  }

  num_nat_gateways = 1

  tags = {
    "Bob" = "Alice"
  }
}

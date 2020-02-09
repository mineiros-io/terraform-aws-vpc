module "vpc" {
  source = "../.."

  vpc_name = "Test"

  cidr_block = "10.0.0.0/16"

  public_subnets = [
    {
      availability_zone = "us-east-1a",
      cidr_block        = "10.0.64.0/21",
      nat_gateway = {
        enabled = true,
        # custom_eip_id = "eipalloc-0745573650c0f7c75"
      }
    },
    {
      availability_zone = "us-east-1a",
      cidr_block        = "10.0.80.0/21",
      nat_gateway = {
        enabled = true
      }
    },
    {
      availability_zone = "us-east-1b",
      cidr_block        = "10.0.96.0/21",

    }
  ]

  tags = {
    "Bob" = "Alice"
  }
}

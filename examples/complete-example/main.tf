# ---------------------------------------------------------------------------------------------------------------------
# CREATE AN EXAMPLE VPC WITH SUBNETS, INTERNET- AND NAT GATEWAYS
# ---------------------------------------------------------------------------------------------------------------------

locals {
  cidr_block = "10.0.0.0/16"
}

module "vpc" {
  source  = "mineiros-io/vpc/aws"
  version = "~> 0.3.0"

  module_enabled = true

  vpc_name   = "main"
  cidr_block = local.cidr_block

  # Define a mode on how to deploy NAT gateways for private networks.
  # Valid values are:
  # - "single" to create a single NAT gateway in the first availability zone to route all private traffic to
  # - "one_per_az" to create a NAT gateway per availability zone that has a private subnet. This needs a public subnets in the same AZs.
  nat_gateway_mode = "single"

  subnets = [
    {
      # define a group name for the subnets. This can be any string. Default is "main".
      group = "main"

      # Class of the subnet: Default is "private".
      # - "public" defines a set of subnets where deployed components can be reachable via the public internet.
      # - "private" defines a set subnets where components are not publicly reachable but can reach the internet.
      # - "intra" (in development) defines a set of subnets that has not connectivity to the public internet.
      class = "public"

      # defines whether components deployed into the subnet will be assigned a public IPv4 address when launched.
      map_public_ip_on_launch = true

      # Define the base CIDR Block of the subnets and the parameters to calculate each CIDR Block. Default is the VPC CIDR Block.
      #   This example: devide the VPC CIDR Block into 2^4 = 16 blocks and use the first block as a base for all subnets
      #                 Add 4 bits to the prefix of "10.0.0.0/16" results in "10.0.0.0/20".
      cidr_block = cidrsubnet(local.cidr_block, 4, 0)

      # How many bits should be added when calculating the subnets CIDR Blocks. Default is 8.
      #   This example: For each subnet add another 4 bits to the prefix, so each netnum will result in:
      #                 netnum=0 => subnet_cidr_block="10.0.0.0/24"
      #                 netnum=1 => subnet_cidr_block="10.0.1.0/24"
      #                  ...
      #                 netnum=15 => subnet_cidr_block="10.0.15.0/24"
      newbits = 4

      # A map of subnets keyed by availability zone suffix. The Number defined the network number with in the CIDR Block.
      # see https://www.terraform.io/docs/configuration/functions/cidrsubnet.html for details on how this is calculated internally
      #  Note: When adjusting cidr_block or newbits you might also need to adjust the netnums.
      #   This Example: Deploy one subnet in availability zone "a" ("10.0.0.0/24") and one subnet in availability zone "b" ("10.0.1.0/24")
      netnums_by_az = {
        a = [0] # "10.0.0.0/24"
        b = [1] # "10.0.1.0/24"
      }

      # A map of tags that will be applied to this Subnet.
      # A "Name" tag of the format '<vpc_name>-<group>-<class>-<az>-<idx>' (idx is the index in the list of netnums)
      # will be applied automatically but can be overwritten.
      # The Name tag will be merged with var.module_tags, var.subnet_tags, tags
      tags = {
      }
    },
    {
      group = "main"
      class = "private"

      # use the second network block for private subnets: "10.0.16.0/20"
      #
      cidr_block = cidrsubnet(local.cidr_block, 4, 1)

      # Add another 4 bits when calculatin actual subnet cidr blocks (see above)
      newbits = 4

      # create four private networks in three availability zones
      #   AZ a: "10.0.16.0/24"
      #   AZ b: "10.0.17.0/24" and "10.0.20.0/24"
      #   AZ c: "10.0.18.0/24"
      netnums_by_az = {
        a = [0]
        b = [1, 4]
        c = [2]
      }
    },
  ]
}

provider "aws" {
  region = "us-east-1"
}

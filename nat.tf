# ---------------------------------------------------------------------------------------------------------------------
# LAUNCH THE NAT GATEWAYS
#
# A NAT Gateway enables instances in the private subnet to connect to the Internet or other AWS services, but prevents
# the Internet from initiating a connection to those instances.
#
# When launching a non-production VPC, route all traffic through a single NAT Gateway in one Availability Zone to
# prevent costs. When launching a production VPC, route traffic through one NAT Gateway per Availability Zone for
# maximum availability.
#
# For production VPCs, a NAT Gateway should be placed in each Availability Zone, whereas for
# non-prod VPCs, just one Availability Zone (and hence 1 NAT Gateway) will suffice.
#
# See https://docs.aws.amazon.com/vpc/latest/userguide/vpc-nat-gateway.html
# ---------------------------------------------------------------------------------------------------------------------

locals {
  # Map create_nat_gateways variable ( string ) to booleans for convenience.
  enable_nat                = var.create_nat_gateways == "none" ? false : true
  create_single_nat_gateway = var.create_nat_gateways == "single" ? true : false

  # Create a grouped map with availability zone as key and a list of cidr blocks as value.
  # This map is used to group the CIDR blocks of our public subnets by availability zone. We use it to decide in which
  # public subnets we should deploy the NAT Gateways in.
  #
  # azs_public_subnets_mapping = {
  #   us-east-1a = [
  #     "10-0-64-0-21",
  #     "10-0-80-0-21"
  #   ],
  #  us-east-1b = [
  #     "10-0-112-0-21",
  #  ]
  # }
  azs_public_subnets_mapping = {
    for cidr, subnet in aws_subnet.public : subnet.availability_zone => cidr...
  }

  # Create a map with availability zone as key and one unique CIDR block as value. If a user decides to deploy a NAT
  # Gateway in each availability zone, we will deploy it inside the first subnet in availability zone x. Since we enable
  # our users to deploy more than one public subnet inside a single availability zone, we need to choose a public subnet
  # to deploy the NAT Gateway in. Otherwise, we would deploy a NAT Gateway in each public subnet inside all availability
  # zones, which isn't an unnecessary overhead and would produce more costs.
  #
  # nat_gateways_availability_zone_cidr_mapping = {
  #   us-east-1a = "10-0-64-0-21",
  #   us-east-1b = "10-0-112-0-21",
  # }
  #
  nat_gateways_availability_zone_cidr_mapping = var.create && local.create_single_nat_gateway == false ? {
    for az, cidrs in local.azs_public_subnets_mapping : az => replace(cidrs[0], "/[./]/", "-")
    } : try(map(element(keys(local.azs_public_subnets_mapping), 0),
  local.azs_public_subnets_mapping[element(keys(local.azs_public_subnets_mapping), 0)][0]), {})
}

# A NAT Gateway must be associated with an Elastic IP Address
resource "aws_eip" "nat" {
  for_each = var.create && local.enable_nat && ! (! var.allow_private_subnets_internet_access && ! var.allow_intra_subnets_internet_access) ? local.nat_gateways_availability_zone_cidr_mapping : {}

  vpc = true
  tags = merge(
    { Name = "${var.vpc_name}-${each.key}-eip" },
    var.eip_tags,
    var.tags
  )

  depends_on = [aws_internet_gateway.internet_gateway]
}

# Create the NAT Gateways
# Currently, this modules provides two scenarios:
# - Create a single NAT Gateway inside the first defined public subnet
# - Create a Nat Gateway in every first public subnet inside each availability zones
resource "aws_nat_gateway" "nat" {
  for_each = var.create && local.enable_nat && ! (! var.allow_private_subnets_internet_access && ! var.allow_intra_subnets_internet_access) ? local.nat_gateways_availability_zone_cidr_mapping : {}

  allocation_id = aws_eip.nat[each.key].id
  subnet_id     = aws_subnet.public[each.value].id

  tags = merge(
    { Name = "${var.vpc_name}-${each.key}-nat-gateway" },
    var.nat_gateway_tags,
    var.tags,
  )

  # It's recommended to denote that the NAT Gateway depends on the Internet Gateway for the VPC in which the NAT
  # Gateway's subnet is located. https://www.terraform.io/docs/providers/aws/r/nat_gateway.html
  depends_on = [aws_internet_gateway.internet_gateway]
}

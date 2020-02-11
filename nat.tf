# ---------------------------------------------------------------------------------------------------------------------
# LAUNCH THE NAT GATEWAYS
#
# A NAT Gateway enables instances in the private subnet to connect to the Internet or other AWS services, but prevents
# the Internet from initiating a connection to those instances.
#
# When launching a development VPC, route all traffic through a single NAT Gateway in one Availability Zone to save
# money.  When launching a production VPC, route traffic through one NAT Gateway per Availability Zone for maximum
# availability.
#
# For production VPCs, a NAT Gateway should be placed in each Availability Zone (so likely 3 total), whereas for
# non-prod VPCs, just one Availability Zone (and hence 1 NAT Gateway) will suffice.
#
# See https://docs.aws.amazon.com/vpc/latest/userguide/vpc-nat-gateway.html
# ---------------------------------------------------------------------------------------------------------------------

locals {
  subnet_keys_list = [
    for id, _subnet in local.public_subnets : id
  ]

  nat_gateways = var.create && var.create_single_nat_only == false ? {
    for id, subnet in local.public_subnets : id => subnet.cidr_block
  } : map(local.subnet_keys_list[0], local.subnet_keys_list[0])
}

# A NAT Gateway must be associated with an Elastic IP Address
resource "aws_eip" "nat" {
  for_each = var.create && var.enable_nat_gateway ? local.nat_gateways : {}

  vpc  = true
  tags = var.tags

  depends_on = [aws_internet_gateway.internet_gateway]
}

# Create the NAT Gateways
# The quantity of created NAT Gateways should be chosen carefully, because each NAT Gateway produces costs 24/7
resource "aws_nat_gateway" "nat" {
  for_each = var.create && var.enable_nat_gateway ? local.nat_gateways : {}

  allocation_id = aws_eip.nat[each.key].id
  subnet_id     = aws_subnet.public[each.key].id

  tags = merge(
    { Name = "${var.vpc_name}-${each.key}-nat-gateway" },
    var.tags,
    var.nat_gateway_tags,
  )

  # It's recommended to denote that the NAT Gateway depends on the Internet Gateway for the VPC in which the NAT
  # Gateway's subnet is located. https://www.terraform.io/docs/providers/aws/r/nat_gateway.html
  depends_on = [aws_internet_gateway.internet_gateway]
}

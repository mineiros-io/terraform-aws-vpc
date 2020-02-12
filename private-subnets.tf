# ---------------------------------------------------------------------------------------------------------------------
# PRIVATE SUBNETS
# ---------------------------------------------------------------------------------------------------------------------

# Prepare local private_subnets data structure
locals {
  private_subnets = { for subnet in var.private_subnets :
    replace(subnet.cidr_block, "/[./]/", "-") => {
      cidr_block                      = subnet.cidr_block
      ipv6_cidr_block                 = try(subnet.ipv6_cidr_block, null)
      availability_zone               = try(subnet.availability_zone, null)
      availability_zone_id            = try(subnet.availability_zone_id, null)
      map_public_ip_on_launch         = try(subnet.map_public_ip_on_launch, false)
      assign_ipv6_address_on_creation = try(subnet.assign_ipv6_address_on_creation, false)
    }
  }
}

# Create a private subnets per AZ for our "App" tier
resource "aws_subnet" "private" {
  for_each = var.create ? local.private_subnets : {}

  vpc_id                          = aws_vpc.vpc[0].id
  cidr_block                      = each.value.cidr_block
  ipv6_cidr_block                 = each.value.ipv6_cidr_block
  availability_zone               = each.value.availability_zone
  availability_zone_id            = each.value.availability_zone_id
  map_public_ip_on_launch         = false
  assign_ipv6_address_on_creation = each.value.assign_ipv6_address_on_creation


  tags = merge(
    { Name = "${var.vpc_name}-private-subnet-${each.key}" },
    var.private_subnet_tags,
    var.tags
  )
}

# Create a Route Table for each private subnet
# - All traffic to endpoints within the subnet to which this is attached will be enabled by default
# - For all non-VPC traffic (i.e. public Internet) traffic, we'll route this to the NAT instance for this Availability
#   Zone.
# Note that we don't need to specify any routing rules because our HA NAT Instance will automatically update
# the Route Table upon booting.
resource "aws_route_table" "private" {
  for_each = aws_subnet.private

  vpc_id = aws_vpc.vpc[0].id

  # toDO: to be implemented
  # propagating_vgws

  tags = merge(
    { Name = "${var.vpc_name}-private-${each.key}" },
    var.private_route_table_tags,
    var.tags
  )
}

# Create a route for outbound Internet traffic.
resource "aws_route" "nat" {
  for_each = var.create && var.enable_nat && var.allow_private_subnets_internet_access ? aws_subnet.private : {}

  route_table_id         = aws_route_table.private[each.key].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = var.create_single_nat_only ? aws_nat_gateway.nat[element(keys(local.nat_gateways_availability_zone_cidr_mapping), 0)].id : try(
    aws_nat_gateway.nat[each.value.availability_zone].id,
    aws_nat_gateway.nat[element(keys(local.nat_gateways_availability_zone_cidr_mapping), 0)].id
  )


  depends_on = [
    aws_internet_gateway.internet_gateway,
    aws_route_table.private,
  ]

  # Workaround for https://github.com/terraform-providers/terraform-provider-aws/issues/338
  timeouts {
    create = "5m"
  }
}

# Associate each private-app subnet with its respective route table
resource "aws_route_table_association" "private" {
  for_each = var.create ? aws_subnet.private : {}

  subnet_id      = each.value.id
  route_table_id = aws_route_table.private[each.key].id
}

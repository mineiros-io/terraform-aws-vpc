# ---------------------------------------------------------------------------------------------------------------------
# PRIVATE PERSISTENCE SUBNETS
# These subnets are private and without connection to the public internet per default. Typically, they are used to
# launch persistence resource such as databases and caches.
# ---------------------------------------------------------------------------------------------------------------------

# Prepare local private_persistence_subnets data structure
locals {
  private_persistence_subnets = { for subnet in var.private_persistence_subnets :
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

resource "aws_subnet" "private_persistence" {
  for_each = var.create ? local.private_persistence_subnets : {}

  vpc_id                          = aws_vpc.vpc[0].id
  cidr_block                      = each.value.cidr_block
  ipv6_cidr_block                 = each.value.ipv6_cidr_block
  availability_zone               = each.value.availability_zone
  availability_zone_id            = each.value.availability_zone_id
  map_public_ip_on_launch         = false
  assign_ipv6_address_on_creation = each.value.assign_ipv6_address_on_creation

  tags = merge(
    { Name = "${var.vpc_name}-private-persistence-subnet-${each.key}" },
    var.private_persistence_subnet_tags,
    var.tags
  )
}

# Create a Route Table for each private persistence subnet
# - All traffic to endpoints within the subnet to which this is attached will be enabled by default
# - No public Internet traffic is permitted, in or out.
resource "aws_route_table" "private_persistence" {
  for_each = aws_subnet.private_persistence
  vpc_id   = aws_vpc.vpc[0].id

  //  propagating_vgws = var.persistence_propagating_vgws

  tags = merge(
    { Name = "${var.vpc_name}-private_persistence-${each.key}" },
    var.private_persistence_route_table_tags,
    var.tags,
  )
}

# Create a route for outbound Internet traffic.
resource "aws_route" "private_persistence_nat" {
  for_each = var.enable_nat && var.allow_private_persistence_subnets_internet_access ? aws_subnet.private_persistence : {}

  route_table_id         = aws_route_table.private_persistence[each.key].id
  destination_cidr_block = "0.0.0.0/0"

  nat_gateway_id = var.create_single_nat_only ? aws_nat_gateway.nat[element(keys(
    local.nat_gateways_availability_zone_cidr_mapping), 0)].id : try(
    aws_nat_gateway.nat[each.value.availability_zone].id,
    aws_nat_gateway.nat[element(keys(local.nat_gateways_availability_zone_cidr_mapping), 0)].id
  )

  depends_on = [
    aws_internet_gateway.internet_gateway,
    aws_route_table.private_persistence,
  ]

  # Workaround for https://github.com/terraform-providers/terraform-provider-aws/issues/338
  timeouts {
    create = "5m"
  }
}

# Associate each private persistence subnet with its respective route table
resource "aws_route_table_association" "private_persistence" {
  for_each = aws_subnet.private_persistence

  subnet_id      = each.value.id
  route_table_id = aws_route_table.private_persistence[each.key].id
}

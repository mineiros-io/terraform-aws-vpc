# ---------------------------------------------------------------------------------------------------------------------
# INTRA SUBNETS - PRIVATE ISOLATED SUBNETS WITH NO NAT CONNECTIVITY ENABLED PER DEFAULT
# These subnets are private and without connection to the public internet per default. Typically, they are used to
# launch persistence resource such as databases and caches or lambdas.
# ---------------------------------------------------------------------------------------------------------------------

# Prepare local intra_subnets data structure
locals {
  intra_subnets = { for subnet in var.intra_subnets :
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

resource "aws_subnet" "intra" {
  for_each = var.create ? local.intra_subnets : {}

  vpc_id                          = aws_vpc.vpc[0].id
  cidr_block                      = each.value.cidr_block
  ipv6_cidr_block                 = each.value.ipv6_cidr_block
  availability_zone               = each.value.availability_zone
  availability_zone_id            = each.value.availability_zone_id
  map_public_ip_on_launch         = false
  assign_ipv6_address_on_creation = each.value.assign_ipv6_address_on_creation

  tags = merge(
    { Name = "${var.vpc_name}-intra-subnet-${each.key}" },
    var.intra_subnet_tags,
    var.tags
  )
}

# Create a Route Table for each intra subnet
# - All traffic to endpoints within the subnet to which this is attached will be enabled by default
# - No public Internet traffic is permitted, in or out.
resource "aws_route_table" "intra" {
  for_each = aws_subnet.intra
  vpc_id   = aws_vpc.vpc[0].id

  //  propagating_vgws = var.persistence_propagating_vgws

  tags = merge(
    { Name = "${var.vpc_name}-intra-${each.key}" },
    var.intra_route_table_tags,
    var.tags,
  )
}

# Create a route for outbound Internet traffic.
resource "aws_route" "intra_nat" {
  for_each = var.enable_nat && var.allow_intra_subnets_internet_access ? aws_subnet.intra : {}

  route_table_id         = aws_route_table.intra[each.key].id
  destination_cidr_block = "0.0.0.0/0"

  nat_gateway_id = var.create_single_nat_only ? aws_nat_gateway.nat[element(keys(
    local.nat_gateways_availability_zone_cidr_mapping), 0)].id : try(
    aws_nat_gateway.nat[each.value.availability_zone].id,
    aws_nat_gateway.nat[element(keys(local.nat_gateways_availability_zone_cidr_mapping), 0)].id
  )

  depends_on = [
    aws_internet_gateway.internet_gateway,
    aws_route_table.intra,
  ]

  # Workaround for https://github.com/terraform-providers/terraform-provider-aws/issues/338
  timeouts {
    create = "5m"
  }
}

# Associate each intra subnet with its respective route table
resource "aws_route_table_association" "intra" {
  for_each = aws_subnet.intra

  subnet_id      = each.value.id
  route_table_id = aws_route_table.intra[each.key].id
}

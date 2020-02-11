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
  count = var.create && length(local.private_subnets) > 0 ? 1 : 0

  vpc_id = aws_vpc.vpc[0].id

  # toDO: to be implemented
  # propagating_vgws

  tags = merge(
    { Name = "${var.vpc_name}-private-${count.index}" },
    var.private_route_table_tags,
    var.tags
  )
}

# Create a route for outbound Internet traffic.
resource "aws_route" "nat" {
  for_each = var.create && var.enable_nat_gateway && var.allow_private_subnets_internet_access ? {
    for id, nat in aws_nat_gateway.nat : id => nat
  } : {}

  route_table_id         = aws_route_table.private[0].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = each.value.id

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
  route_table_id = aws_route_table.private[0].id
}

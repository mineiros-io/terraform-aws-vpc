# ---------------------------------------------------------------------------------------------------------------------
# PUBLIC SUBNETS
# ---------------------------------------------------------------------------------------------------------------------

# Prepare local public_subnets data structure
locals {
  public_subnets = { for subnet in var.public_subnets :
    replace(subnet.cidr_block, "/[./]/", "-") => {
      cidr_block                      = subnet.cidr_block
      ipv6_cidr_block                 = try(subnet.ipv6_cidr_block, null)
      availability_zone               = try(subnet.availability_zone, null)
      availability_zone_id            = try(subnet.availability_zone_id, null)
      map_public_ip_on_launch         = try(subnet.map_public_ip_on_launch, false)
      assign_ipv6_address_on_creation = try(subnet.assign_ipv6_address_on_creation, false)
      nat_gateway = {
        enabled       = try(subnet.nat_gateway.enabled, false)
        custom_eip_id = try(subnet.nat_gateway.custom_eip_id, null)
      }
    }
  }
}

# Creates a range of public subnets
resource "aws_subnet" "public" {
  for_each = var.create ? local.public_subnets : {}

  vpc_id                          = aws_vpc.vpc[0].id
  cidr_block                      = each.value.cidr_block
  ipv6_cidr_block                 = each.value.ipv6_cidr_block
  availability_zone               = each.value.availability_zone
  availability_zone_id            = each.value.availability_zone_id
  map_public_ip_on_launch         = each.value.map_public_ip_on_launch
  assign_ipv6_address_on_creation = each.value.assign_ipv6_address_on_creation

  tags = merge(
    { Name = "${var.vpc_name}-public-subnet-${each.key}" },
    var.public_subnet_tags,
    var.tags
  )
}

# Create a single Route Table for public subnets
# - This routes all public traffic through the Internet gateway
# - All traffic to endpoints within the VPC won't hit the public internet
resource "aws_route_table" "public" {
  count = var.create && length(local.public_subnets) > 0 ? 1 : 0

  vpc_id = aws_vpc.vpc[0].id
  tags = merge(
    { Name = "${var.vpc_name}-public-subnet-route-table" },
    var.public_route_table_tags,
    var.tags
  )
}

# Route all traffic to the public internet through the internet gateway
resource "aws_route" "internet" {
  count = var.create && length(local.public_subnets) > 0 ? 1 : 0

  route_table_id         = aws_route_table.public[0].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.internet_gateway[0].id

  # Workaround for https://github.com/terraform-providers/terraform-provider-aws/issues/338
  timeouts {
    create = "5m"
  }
}

# Associate each public subnet with a public route table
resource "aws_route_table_association" "public" {
  for_each = var.create ? aws_subnet.public : {}

  subnet_id      = each.value.id
  route_table_id = aws_route_table.public[0].id
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE PUBLIC ROUTING AND AN INTERNET GATEWAY IF A PUBLIC SUBNET IS DEFINED
# ---------------------------------------------------------------------------------------------------------------------

locals {
  public_subnets = [for subnet in local.subnets : subnet if subnet.class == "public"]

  public_groups = try(distinct(local.public_subnets.*.group), [])

  public_subnets_by_group = {
    for group in local.public_groups : group => [
      for subnet in local.public_subnets : subnet if subnet.group == group
    ]
  }
}

resource "aws_internet_gateway" "internet_gateway" {
  count = var.module_enabled && length(local.public_subnets) > 0 ? 1 : 0

  vpc_id = aws_vpc.vpc[0].id

  tags = merge(
    {
      Name = var.vpc_name
    },
    var.module_tags,
    var.internet_gateway_tags,
  )

  depends_on = [var.module_depends_on]
}

resource "aws_route_table" "public" {
  for_each = var.module_enabled ? local.public_subnets_by_group : {}

  vpc_id = aws_vpc.vpc[0].id

  # propagating_vgws = try(local.subnets[each.key].propagating_vgws, null)

  tags = merge(
    {
      Name = "${var.vpc_name}-public-${each.key}"
    },
    var.module_tags,
    var.route_table_tags,
    var.public_route_table_tags,
  )

  depends_on = [var.module_depends_on]
}

resource "aws_route_table_association" "public" {
  for_each = var.module_enabled ? {
    for subnet in flatten(values(local.public_subnets_by_group)) : subnet.cidr_block => subnet
  } : {}

  subnet_id      = aws_subnet.subnet[each.key].id
  route_table_id = aws_route_table.public[each.value.group].id

  depends_on = [var.module_depends_on]
}

resource "aws_route" "internet_gateway" {
  for_each = aws_route_table.public

  route_table_id         = each.value.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.internet_gateway[0].id

  # Workaround for https://github.com/terraform-providers/terraform-provider-aws/issues/338
  timeouts {
    create = "10m"
  }

  depends_on = [var.module_depends_on]
}

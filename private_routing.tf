# ---------------------------------------------------------------------------------------------------------------------
# CREATE PRIVATE ROUTING AND NAT GATEWAYS IF A PRIVATE SUBNETS IS DEFINED
# ---------------------------------------------------------------------------------------------------------------------

locals {
  private_subnets = [for subnet in local.subnets : subnet if subnet.class == "private"]

  private_group_azs = try(distinct(local.private_subnets.*.group_az), [])

  public_azs  = try(distinct(local.public_subnets.*.availability_zone), [])
  private_azs = try(distinct(local.private_subnets.*.availability_zone), [])

  private_groups = try(distinct(local.private_subnets.*.group), [])

  private_subnets_by_group = {
    for group in local.private_groups : group => [
      for subnet in local.private_subnets : subnet if subnet.group == group
    ]
  }

  private_subnets_by_group_az = {
    for group_az in local.private_group_azs : group_az => [
      for subnet in local.private_subnets : subnet if subnet.group_az == group_az
    ]
  }

  public_subnets_by_az = {
    for az in local.public_azs : az => [
      for subnet in local.public_subnets : subnet if subnet.availability_zone == az
    ]
  }

  # hacky assertion
  assert_each_private_subnet_has_a_public_in_same_az = {
    for az in local.missing_public_subnet_azs[var.nat_gateway_mode] : "Missing public subnet in az" => local.public_subnets_by_az[az]
  }

  nat_gateway_single_zones = var.nat_gateway_single_mode_zone != null ? ["${local.region}-${var.nat_gateway_single_mode_zone}"] : try([local.matching_azs[0]], [])

  matching_azs = sort(setintersection(local.public_azs, local.private_azs))
  nat_azs = {
    one_per_az = local.matching_azs
    single     = local.nat_gateway_single_zones
    none       = []
  }

  nat_azs_set = toset(local.nat_azs[var.nat_gateway_mode])

  missing_public_subnet_azs = {
    one_per_az = sort(setsubtract(local.private_azs, local.public_azs))
    single     = length(local.matching_azs) == 0 ? sort(setsubtract(local.private_azs, local.public_azs)) : []
    none       = []
  }
}

resource "aws_eip" "eip" {
  for_each = var.module_enabled ? local.nat_azs_set : []

  vpc = true

  tags = merge(
    {
      Name = "${var.vpc_name}-nat-private-${each.key}"

      # special mineiros.io tags that can be used in data sources
      "mineiros-io/aws/vpc/vpc-name"   = var.vpc_name
      "mineiros-io/aws/vpc/natgw-name" = "${var.vpc_name}-${each.key}"
      "mineiros-io/aws/vpc/eip-name"   = "${var.vpc_name}-nat-private-${each.key}"
    },
    var.module_tags,
    var.eip_tags,
  )

  depends_on = [var.module_depends_on]
}

resource "aws_nat_gateway" "nat_gateway" {
  for_each = var.module_enabled ? local.nat_azs_set : []

  allocation_id = aws_eip.eip[each.key].id
  subnet_id     = aws_subnet.subnet[local.public_subnets_by_az[each.key][0].cidr_block].id

  tags = merge(
    {
      Name = "${var.vpc_name}-${each.key}"

      # special mineiros.io tags that can be used in data sources
      "mineiros-io/aws/vpc/vpc-name"   = var.vpc_name
      "mineiros-io/aws/vpc/natgw-name" = "${var.vpc_name}-${each.key}"
    },
    var.module_tags,
    var.nat_gateway_tags,
  )

  depends_on = [var.module_depends_on]
}

resource "aws_route_table" "private" {
  for_each = var.module_enabled ? local.private_subnets_by_group_az : {}

  vpc_id = aws_vpc.vpc[0].id

  # propagating_vgws = try(local.subnets[each.key].propagating_vgws, null)

  tags = merge(
    {
      Name = "${var.vpc_name}-private-${each.key}"

      # special mineiros.io tags that can be used in data sources
      "mineiros-io/aws/vpc/vpc-name"         = var.vpc_name
      "mineiros-io/aws/vpc/routetable-name"  = "${var.vpc_name}-private-${each.key}"
      "mineiros-io/aws/vpc/routetable-class" = "private"
    },
    var.module_tags,
    var.route_table_tags,
    var.private_route_table_tags,
  )

  depends_on = [var.module_depends_on]
}

resource "aws_route_table_association" "private" {
  for_each = var.module_enabled ? {
    for subnet in flatten(values(local.private_subnets_by_group_az)) : subnet.cidr_block => subnet
  } : {}

  subnet_id      = aws_subnet.subnet[each.key].id
  route_table_id = aws_route_table.private[each.value.group_az].id

  depends_on = [var.module_depends_on]
}

locals {
  nat_routes = { for k, v in aws_route_table.private : "${var.nat_gateway_mode}/${k}" => v }
}

resource "aws_route" "nat_gateway" {
  for_each = length(local.nat_azs_set) > 0 ? local.nat_routes : {}

  route_table_id         = each.value.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = try(
    aws_nat_gateway.nat_gateway[local.private_subnets_by_group_az[each.key][0].availability_zone].id,
    element(values(aws_nat_gateway.nat_gateway)[*].id, 0),
    null,
  )

  # Workaround for https://github.com/terraform-providers/terraform-provider-aws/issues/338
  timeouts {
    create = "10m"
  }

  # we depend on nat gateways to be available for setting and updating routes
  # the implicit dependency does not work, when changing nat gateway mode as we will
  # only depend on the new gateway implictly and not on the one being removed.
  # (e.g. when switching nat_gateway_mode)
  depends_on = [
    var.module_depends_on,
    aws_nat_gateway.nat_gateway,
  ]
}

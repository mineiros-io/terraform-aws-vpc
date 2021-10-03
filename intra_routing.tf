# ---------------------------------------------------------------------------------------------------------------------
# CREATE intra ROUTING AND AN INTERNET GATEWAY IF A intra SUBNETS IS DEFINED
# ---------------------------------------------------------------------------------------------------------------------

locals {
  intra_subnets = [for subnet in local.subnets : subnet if subnet.class == "intra"]

  intra_groups = try(distinct(local.intra_subnets.*.group), [])

  intra_subnets_by_group = {
    for group in local.intra_groups : group => [
      for subnet in local.intra_subnets : subnet if subnet.group == group
    ]
  }
}

resource "aws_route_table" "intra" {
  for_each = var.module_enabled ? local.intra_subnets_by_group : {}

  vpc_id = aws_vpc.vpc[0].id

  # propagating_vgws = try(local.subnets[each.key].propagating_vgws, null)

  tags = merge(
    {
      Name = "${var.vpc_name}-intra-${each.key}"

      # special mineiros.io tags that can be used in data sources
      "mineiros-io/aws/vpc/vpc-name"         = var.vpc_name
      "mineiros-io/aws/vpc/routetable-name"  = "${var.vpc_name}-intra-${each.key}"
      "mineiros-io/aws/vpc/routetable-class" = "intra"
    },
    var.module_tags,
    var.route_table_tags,
    var.intra_route_table_tags,
  )

  depends_on = [var.module_depends_on]
}

resource "aws_route_table_association" "intra" {
  for_each = var.module_enabled ? {
    for subnet in flatten(values(local.intra_subnets_by_group)) : subnet.cidr_block => subnet
  } : {}

  subnet_id      = aws_subnet.subnet[each.key].id
  route_table_id = aws_route_table.intra[each.value.group].id

  depends_on = [var.module_depends_on]
}

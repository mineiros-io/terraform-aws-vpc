locals {
  subnets_with_elasticache_subnet_group = { for subnet in var.subnets : subnet.elasticache_subnet_group_name => subnet if can(subnet.elasticache_subnet_group_name) }
}

resource "aws_elasticache_subnet_group" "elasticache_subnet_group" {
  for_each = local.subnets_with_elasticache_subnet_group

  name        = each.key
  subnet_ids  = [for subnet in local.subnets : aws_subnet.subnet[subnet.cidr_block].id if subnet.elasticache_subnet_group_name == each.key]
  description = try(each.value.description, "Managed by mineiros-io/vpc/aws Terraform Module")

  tags = merge(var.module_tags, try(each.value.tags, {}))
}

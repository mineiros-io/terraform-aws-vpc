# ----------------------------------------------------------------------------------------------------------------------
# OUTPUT CALCULATED VARIABLES (prefer full objects)
# ----------------------------------------------------------------------------------------------------------------------

locals {
  public_aws_subnets_by_group = {
    for group, subnets in local.public_subnets_by_group : group => [
      for subnet in aws_subnet.subnet : subnet if contains(subnets.*.cidr_block, subnet.cidr_block)
    ]
  }

  private_aws_subnets_by_group = {
    for group, subnets in local.private_subnets_by_group : group => [
      for subnet in aws_subnet.subnet : subnet if contains(subnets.*.cidr_block, subnet.cidr_block)
    ]
  }

  intra_aws_subnets_by_group = {
    for group, subnets in local.intra_subnets_by_group : group => [
      for subnet in aws_subnet.subnet : subnet if contains(subnets.*.cidr_block, subnet.cidr_block)
    ]
  }

  public_subnet_ids_by_group = {
    for group, subnets in local.public_aws_subnets_by_group : group => subnets.*.id
  }

  private_subnet_ids_by_group = {
    for group, subnets in local.private_aws_subnets_by_group : group => subnets.*.id
  }

  intra_subnet_ids_by_group = {
    for group, subnets in local.intra_aws_subnets_by_group : group => subnets.*.id
  }

  public_route_table_ids_by_group = {
    for group, subnet_ids in local.public_subnet_ids_by_group : group => distinct([
      for rta in try(values(aws_route_table_association.public), []) :
      rta.route_table_id if contains(subnet_ids, rta.subnet_id)
    ])
  }

  private_route_table_ids_by_group = {
    for group, subnet_ids in local.private_subnet_ids_by_group : group => distinct([
      for rta in try(values(aws_route_table_association.private), []) :
      rta.route_table_id if contains(subnet_ids, rta.subnet_id)
    ])
  }

  intra_route_table_ids_by_group = {
    for group, subnet_ids in local.intra_subnet_ids_by_group : group => distinct([
      for rta in try(values(aws_route_table_association.intra), []) :
      rta.route_table_id if contains(subnet_ids, rta.subnet_id)
    ])
  }
}


output "public_subnets_by_group" {
  description = "A map of lists of public subnets keyed by group. (aws_subnet)"
  value       = local.public_aws_subnets_by_group
}

output "public_route_table_ids_by_group" {
  description = "A map of lists of public route table IDs keyed by group."
  value       = local.public_route_table_ids_by_group
}

output "public_subnet_ids_by_group" {
  description = "A map of lists of public subnet IDs keyed by group."
  value       = local.public_subnet_ids_by_group
}

output "private_subnets_by_group" {
  description = "A map of lists of private subnets keyed by group. (aws_subnet)"
  value       = local.private_aws_subnets_by_group
}

output "private_route_table_ids_by_group" {
  description = "A map of lists of private route table IDs keyed by group."
  value       = local.private_route_table_ids_by_group
}

output "private_subnet_ids_by_group" {
  description = "A map of lists of private subnet IDs keyed by group."
  value       = local.private_subnet_ids_by_group
}

output "intra_subnets_by_group" {
  description = "A map of lists of intra aws_subnet keyed by group. (aws_subnet)"
  value       = local.intra_aws_subnets_by_group
}

output "intra_route_table_ids_by_group" {
  description = "A map of lists of intra route table IDs keyed by group."
  value       = local.intra_route_table_ids_by_group
}

output "intra_subnet_ids_by_group" {
  description = "A map of lists of intra subnet IDs keyed by group."
  value       = local.intra_subnet_ids_by_group
}

# ----------------------------------------------------------------------------------------------------------------------
# OUTPUT ALL RESOURCES AS FULL OBJECTS
# ----------------------------------------------------------------------------------------------------------------------

output "vpc" {
  description = "The VPC. (aws_vpc)"
  value       = try(aws_vpc.vpc[0], null)
}

output "intra_route_tables" {
  description = "A map of intra route tables keyed by group. (aws_route_table)"
  value       = try(aws_route_table.intra, null)
}

output "intra_route_table_associations" {
  description = "A map of intra route table associations keyed by the subnets CIDR Blocks. (aws_route_table_association)"
  value       = try(aws_route_table_association.intra, null)
}

output "eips" {
  description = "A map of Elastic IP Adresses (EIPs) keyed by availability zone. (aws_eip)"
  value       = try(aws_eip.eip, null)
}

output "nat_gateways" {
  description = "A map of NAT gatweways keyed by availability zone. (aws_nat_gateway)"
  value       = try(aws_nat_gateway.nat_gateway, null)
}

output "private_route_tables" {
  description = "A map of private route tables keyed by group. (aws_route_table)"
  value       = try(aws_route_table.private, null)
}

output "private_route_table_associations" {
  description = "A map of private route table associations keyed by the subnets CIDR Blocks. (aws_route_table_association)"
  value       = try(aws_route_table_association.private, null)
}

output "routes_to_nat_gateways" {
  description = "A map of routes to the NAT Gateways keyed by group. (aws_route)"
  value       = try(aws_route.nat_gateway, null)
}

output "internet_gateway" {
  description = "The Internet Gateway. (aws_internet_gateway)"
  value       = try(aws_internet_gateway.internet_gateway[0], null)
}

output "public_route_tables" {
  description = "A map of public route tables keyed by group. (aws_route_table)"
  value       = try(aws_route_table.public, null)
}

output "public_route_table_associations" {
  description = "A map of public route table associations keyed by the subnets CIDR Blocks. (aws_route_table_association)"
  value       = try(aws_route_table_association.public, null)
}

output "routes_to_internet_gateway" {
  description = "A map of routes to the Internet Gateway keyed by group. (aws_route)"
  value       = try(aws_route.internet_gateway, null)
}

output "subnets" {
  description = "A map of subnets keyed by CIDR Blocks. (aws_subnet)"
  value       = try(aws_subnet.subnet, null)
}

# ----------------------------------------------------------------------------------------------------------------------
# OUTPUT ALL INPUT VARIABLES
# ----------------------------------------------------------------------------------------------------------------------

output "module_inputs" {
  description = "A map of all module arguments. Set to the provided values or calculated default values."
  value = {
    vpc_name                         = var.vpc_name
    cidr_block                       = var.cidr_block
    assign_generated_ipv6_cidr_block = var.assign_generated_ipv6_cidr_block
    enable_classiclink               = var.enable_classiclink
    enable_classiclink_dns_support   = var.enable_classiclink_dns_support
    enable_dns_support               = var.enable_dns_support
    enable_dns_hostnames             = var.enable_dns_hostnames
    instance_tenancy                 = var.instance_tenancy

    subnets = var.subnets

    nat_gateway_mode = var.nat_gateway_mode

    vpc_tags              = merge(var.module_tags, var.vpc_tags)
    internet_gateway_tags = merge(var.module_tags, var.internet_gateway_tags)
    eip_tags              = merge(var.module_tags, var.eip_tags)
    nat_gateway_tags      = merge(var.module_tags, var.nat_gateway_tags)

    subnet_tags         = merge(var.module_tags, var.subnet_tags)
    public_subnet_tags  = merge(var.module_tags, var.subnet_tags, var.public_subnet_tags)
    private_subnet_tags = merge(var.module_tags, var.subnet_tags, var.private_subnet_tags)
    intra_subnet_tags   = merge(var.module_tags, var.subnet_tags, var.intra_subnet_tags)

    route_table_tags         = merge(var.module_tags, var.route_table_tags)
    public_route_table_tags  = merge(var.module_tags, var.route_table_tags, var.public_route_table_tags)
    private_route_table_tags = merge(var.module_tags, var.route_table_tags, var.private_route_table_tags)
    intra_route_table_tags   = merge(var.module_tags, var.route_table_tags, var.intra_route_table_tags)
  }
}

# ----------------------------------------------------------------------------------------------------------------------
# OUTPUT MODULE CONFIGURATION
# ----------------------------------------------------------------------------------------------------------------------

output "module_enabled" {
  description = "Whether the module is enabled."
  value       = var.module_enabled
}

output "module_tags" {
  description = "A map of tags that will be applied to all created resources that accept tags."
  value       = var.module_tags
}

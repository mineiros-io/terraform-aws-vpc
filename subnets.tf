# ---------------------------------------------------------------------------------------------------------------------
# CREATE PUBLIC, PRIVATE, AND INTRA SUBNETS WITHIN THE VPC
# ---------------------------------------------------------------------------------------------------------------------

locals {

  # hacky assertion
  assert_subnet_have_unique_group_class_combination = {
    for subnet in var.subnets :
    "${subnet.group}-${subnet.class}" => "class/group combination must be unique in all subnets. See the module's README.md for details."
  }

  subnet_tags = {
    public  = var.public_subnet_tags
    private = var.private_subnet_tags
    intra   = var.intra_subnet_tags
  }

  # The following creates a list of subnets by constructing multi-level lists and flattening them in the end.
  subnets_tmp = flatten(
    [
      for subnet in var.subnets : [
        for az, netnums in subnet.netnums_by_az : [
          for idx, netnum in netnums : {
            cidr_block        = cidrsubnet(try(subnet.cidr_block, var.cidr_block), try(subnet.newbits, 8), netnum)
            availability_zone = "${local.region}${az}"

            map_public_ip_on_launch = try(subnet.map_public_ip_on_launch, subnet.class == "public", false)

            group_az = "${try(subnet.group, "default")}-${local.region}${az}"

            group = try(subnet.group, "default")
            class = try(subnet.class, "private")

            db_subnet_group_name = try(subnet.db_subnet_group_name, null)
            # routes = try(subnet.routes, [])

            tags = merge(
              {
                Name = "${var.vpc_name}-${subnet.group}-${subnet.class}-${az}-${idx}"

                # special mineiros.io tags that can be used in data sources
                "mineiros-io/aws/vpc/vpc-name"     = var.vpc_name
                "mineiros-io/aws/vpc/subnet-name"  = "${var.vpc_name}-${try(subnet.group, "default")}-${try(subnet.class, "private")}-${az}-${idx}"
                "mineiros-io/aws/vpc/subnet-group" = try(subnet.group, "default")
                "mineiros-io/aws/vpc/subnet-class" = try(subnet.class, "private")
              },
              local.subnet_tags[try(subnet.class, "private")],
              try(subnet.tags, {}),
            )
          }
        ]
      ]
    ]
  )

  subnets = {
    for subnet in local.subnets_tmp : subnet.cidr_block => subnet
  }
}

resource "aws_subnet" "subnet" {
  for_each = var.module_enabled ? local.subnets : {}

  vpc_id = aws_vpc.vpc[0].id

  # We convert the cidr_block to its cannonical form. This is actually not needed as we
  # already calculate the cidr_block, but to be future proof we do it again anyway.
  cidr_block = cidrsubnet(each.value.cidr_block, 0, 0)

  availability_zone       = each.value.availability_zone
  map_public_ip_on_launch = each.value.map_public_ip_on_launch

  ipv6_cidr_block                 = try(cidrsubnet(each.value.ipv6_cidr_block, 0, 0), null)
  assign_ipv6_address_on_creation = try(each.value.assign_ipv6_address_on_creation, null)

  tags = merge(
    var.module_tags,
    var.subnet_tags,
    each.value.tags,
  )

  depends_on = [var.module_depends_on]
}

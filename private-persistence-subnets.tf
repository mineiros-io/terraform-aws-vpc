# ---------------------------------------------------------------------------------------------------------------------
# PRIVATE PERSISTENCE SUBNETS
# These subnets are private and without connection to the public internet per default. Typically, they are used to
# launch persistence resource such as databases and caches.
# ---------------------------------------------------------------------------------------------------------------------

# Prepare local private_persistence_subnets data structure
//locals {
//  private_persistence_subnets = { for subnet in var.private_persistence_subnets :
//    replace(subnet.cidr_block, "/[./]/", "-") => {
//      cidr_block                      = subnet.cidr_block
//      ipv6_cidr_block                 = try(subnet.ipv6_cidr_block, null)
//      availability_zone               = try(subnet.availability_zone, null)
//      availability_zone_id            = try(subnet.availability_zone_id, null)
//      map_public_ip_on_launch         = try(subnet.map_public_ip_on_launch, false)
//      assign_ipv6_address_on_creation = try(subnet.assign_ipv6_address_on_creation, false)
//    }
//  }
//}
//
//# Create one private subnet per AZ for our "Persistence" tier
//resource "aws_subnet" "private-persistence" {
//  count             = data.template_file.num_availability_zones.rendered
//  vpc_id            = aws_vpc.main.id
//  availability_zone = element(data.aws_availability_zones.all.names, count.index)
//  cidr_block = lookup(
//  var.private_persistence_subnet_cidr_blocks,
//  "AZ-${count.index}",
//  cidrsubnet(var.cidr_block, var.persistence_subnet_bits, count.index + (2 * var.subnet_spacing)),
//  )
//  tags = merge(
//  { Name = "${var.vpc_name}-private-persistence-${count.index}" },
//  var.custom_tags,
//  var.private_persistence_subnet_custom_tags,
//  )
//}

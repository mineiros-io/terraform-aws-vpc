# ---------------------------------------------------------------------------------------------------------------------
# Create a VPC
# ---------------------------------------------------------------------------------------------------------------------

# Create the VPC
#
# When you create a VPC, we recommend that you specify a CIDR block (of /16 or smaller) from the private IPv4 address
# ranges as specified in RFC 1918 (http://www.faqs.org/rfcs/rfc1918.html):
# - 10.0.0.0 - 10.255.255.255 (10/8 prefix)
# - 172.16.0.0 - 172.31.255.255 (172.16/12 prefix)
# - 192.168.0.0 - 192.168.255.255 (192.168/16 prefix)
#
# The first four IP addresses and the last IP address in each subnet CIDR block are not available for you to use, and
# cannot be assigned to an instance. For example, in a subnet with CIDR block 10.0.0.0/24, the following five IP
# addresses are reserved:
# - 10.0.0.0: Network address.
# - 10.0.0.1: Reserved by AWS for the VPC router.
# - 10.0.0.2: Reserved by AWS. The IP address of the DNS server is the base of the VPC network range plus two.
#

resource "aws_vpc" "vpc" {
  cidr_block                       = var.cidr_block
  instance_tenancy                 = var.instance_tenancy
  enable_dns_support               = var.enable_dns_support
  enable_dns_hostnames             = var.enable_dns_hostnames
  enable_classiclink               = var.enable_classiclink
  enable_classiclink_dns_support   = var.enable_classiclink_dns_support
  assign_generated_ipv6_cidr_block = var.assign_generated_ipv6_cidr_block

  tags = merge(
    { Name = var.vpc_name },
    var.vpc_tags,
    var.tags
  )
}

# Create an Internet Gateway for the VPC
# An internet gateway is a horizontally scaled, redundant, and highly available VPC component that allows communication
# between instances in your VPC and the internet.
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id

  tags = merge(
    { Name = var.vpc_name },
    var.internet_gateway_tags,
    var.tags
  )
}

# Prepare local subnet data structure
locals {
  public_subnets = {
    for public_subnet in var.public_subnets :
    replace(replace(public_subnet.cidr, ".", "-"), "/", "-") => {
      availability_zone = public_subnet.availability_zone
      cidr              = public_subnet.cidr
      nat_gateway = {
        enabled       = try(public_subnet.nat_gateway.enabled, false)
        custom_eip_id = try(public_subnet.nat_gateway.custom_eip_id, null)
      }
    }
  }

}

# Creates a range of public subnets
resource "aws_subnet" "public" {
  for_each = local.public_subnets

  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = each.value["availability_zone"]
  cidr_block              = each.value["cidr"]
  map_public_ip_on_launch = var.map_public_ip_on_launch

  tags = merge(
    { Name = "${var.vpc_name}-public-subnet-${each.value["availability_zone"]}-${each.key}" },
    var.public_subnet_tags,
    var.tags
  )
}

# Create a Route Table for public subnets
# - This routes all public traffic through the Internet gateway
# - All traffic to endpoints within the VPC won't hit the public internet
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id
  tags = merge(
    { Name = "${var.vpc_name}-public-subnet-route-table" },
    var.public_route_table_tags,
    var.tags
  )
}

# It's important that we define this route as a separate terraform resource and not inline in aws_route_table.public because
# otherwise Terraform will not function correctly, per the note at https://www.terraform.io/docs/providers/aws/r/route.html.
resource "aws_route" "internet" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.internet_gateway.id

  # Workaround for https://github.com/terraform-providers/terraform-provider-aws/issues/338
  timeouts {
    create = "5m"
  }
}

# Associate each public subnet with a public route table
resource "aws_route_table_association" "public" {
  for_each = aws_subnet.public

  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

# ---------------------------------------------------------------------------------------------------------------------
# LAUNCH THE NAT GATEWAYS
#
# A NAT Gateway enables instances in the private subnet to connect to the Internet or other AWS services, but prevents
# the Internet from initiating a connection to those instances.
#
# When launching a development VPC, route all traffic through a single NAT Gateway in one Availability Zone to save
# money.  When launching a production VPC, route traffic through one NAT Gateway per Availability Zone for maximum
# availability.
#
# For production VPCs, a NAT Gateway should be placed in each Availability Zone (so likely 3 total), whereas for
# non-prod VPCs, just one Availability Zone (and hence 1 NAT Gateway) will suffice.
#
# See https://docs.aws.amazon.com/vpc/latest/userguide/vpc-nat-gateway.html
# ---------------------------------------------------------------------------------------------------------------------

# A NAT Gateway must be associated with an Elastic IP Address
resource "aws_eip" "nat" {
  for_each = {
    for cidr, subnet in aws_subnet.public : cidr => subnet
    if local.public_subnets[cidr].nat_gateway.enabled == true &&
    local.public_subnets[cidr].nat_gateway.custom_eip_id == null
  }

  vpc  = true
  tags = var.tags

  depends_on = [aws_internet_gateway.internet_gateway]
}

# Create the NAT Gateways
# The quantity of created NAT Gateways should be chosen carefully, because each NAT Gateway produces costs 24/7
resource "aws_nat_gateway" "nat" {
  for_each = {
    for cidr, subnet in aws_subnet.public : cidr => subnet
    if local.public_subnets[cidr].nat_gateway.enabled
  }

  allocation_id = local.public_subnets[each.key].nat_gateway.custom_eip_id == null ? aws_eip.nat[each.key].id : local.public_subnets[each.key].nat_gateway.custom_eip_id

  # ToDO: Routing
  subnet_id = aws_subnet.public[each.key].id

  tags = merge(
    { Name = "${var.vpc_name}-${each.key}-nat-gateway" },
    var.tags,
    var.nat_gateway_tags,
  )

  # It's recommended to denote that the NAT Gateway depends on the Internet Gateway for the VPC in which the NAT
  # Gateway's subnet is located. https://www.terraform.io/docs/providers/aws/r/nat_gateway.html
  depends_on = [aws_internet_gateway.internet_gateway]
}

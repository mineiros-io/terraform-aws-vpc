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
  count = var.create ? 1 : 0

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
  # we only need to start an internet gateway if we provision at least one subnet
  count = var.create && length(aws_subnet.public) > 0 && length(aws_subnet.private) > 0 && length(aws_subnet.private_persistence) > 0 ? 1 : 0

  vpc_id = aws_vpc.vpc[0].id

  tags = merge(
    { Name = var.vpc_name },
    var.internet_gateway_tags,
    var.tags
  )
}

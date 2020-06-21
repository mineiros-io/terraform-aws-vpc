# ---------------------------------------------------------------------------------------------------------------------
# DEPLOY AND MANAGE A VPC
# ---------------------------------------------------------------------------------------------------------------------

# ---------------------------------------------------------------------------------------------------------------------
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
# ---------------------------------------------------------------------------------------------------------------------

data "aws_region" "region" {
  count = var.module_enabled ? 1 : 0
}

locals {
  region = try(data.aws_region.region[0].name, "")
}

resource "aws_vpc" "vpc" {
  count = var.module_enabled ? 1 : 0

  cidr_block                       = var.cidr_block
  instance_tenancy                 = var.instance_tenancy
  enable_dns_support               = var.enable_dns_support
  enable_dns_hostnames             = var.enable_dns_hostnames
  enable_classiclink               = var.enable_classiclink
  enable_classiclink_dns_support   = var.enable_classiclink_dns_support
  assign_generated_ipv6_cidr_block = var.assign_generated_ipv6_cidr_block

  tags = merge(
    { Name = var.vpc_name },
    var.module_tags,
    var.vpc_tags,
  )

  depends_on = [var.module_depends_on]
}

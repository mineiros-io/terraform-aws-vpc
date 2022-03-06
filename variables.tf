# ----------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# These variables must be set when using this module.
# ----------------------------------------------------------------------------------------------------------------------

# ----------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These variables have defaults, but may be overridden.
# ----------------------------------------------------------------------------------------------------------------------

variable "vpc_name" {
  description = "(Optional) The name of the VPC. Default is \"main\"."
  type        = string
  default     = "main"
}

variable "cidr_block" {
  description = "(Optional) The CIDR block for the VPC. The permissible size of the block ranges between a /16 netmask and a /28 netmask. We advice you to use a CIDR block reserved for private address space as recommended in RFC 1918 http://www.faqs.org/rfcs/rfc1918.html. Default is \"10.0.0.0/16\""
  type        = string
  default     = "10.0.0.0/16"
}

variable "assign_generated_ipv6_cidr_block" {
  description = "(Optional) Requests an AWS-provided IPv6 CIDR block with a /56 prefix length for the VPC. You cannot specify the range of IP addresses, or the size of the CIDR block. Default is false."
  type        = bool
  default     = false
}

variable "enable_classiclink" {
  description = "(Optional) Whether or not to enable ClassicLink for the VPC. Only valid in regions and accounts that support EC2 Classic. Read more: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/vpc-classiclink.html. Default is false."
  type        = bool
  default     = false
}

variable "enable_classiclink_dns_support" {
  description = "(Optional) Whether or not to enable ClassicLink DNS Support for the VPC. Only valid in regions and accounts that support EC2 Classic. Default is false."
  type        = bool
  default     = false
}

variable "enable_dns_support" {
  description = "(Optional) Whether or not to enable DNS support in the VPC. Default is true."
  type        = bool
  default     = true
}

variable "enable_dns_hostnames" {
  description = "(Optional) Whether or not to enable DNS hostnames in the VPC. Default is false."
  type        = bool
  default     = false
}

variable "instance_tenancy" {
  description = "(Optional) A tenancy option for instances launched into the VPC. Default is \"default\"."
  type        = string
  default     = "default"
}

variable "vpc_tags" {
  description = "(Optional) A map of tags to apply to the created VPC. Default is {}."
  type        = map(string)
  default     = {}
}

variable "subnets" {
  description = "(Optional) List of subnet definitions. See README.md for details. Default is []."
  type        = any
  default     = []
}

variable "subnet_tags" {
  description = "(Optional) A map of tags to apply to the created Subnet. Default is {}."
  type        = map(string)
  default     = {}
}

variable "public_subnet_tags" {
  description = "(Optional) A map of tags to apply to the created Public Subnets. Default is {}."
  type        = map(string)
  default     = {}
}

variable "private_subnet_tags" {
  description = "(Optional) A map of tags to apply to the created Private Subnets. Default is {}."
  type        = map(string)
  default     = {}
}

variable "intra_subnet_tags" {
  description = "(Optional) A map of tags to apply to the created Intra Subnets. Default is {}."
  type        = map(string)
  default     = {}
}

variable "route_table_tags" {
  description = "(Optional) A map of tags to apply to the created Public Route Table. Default is {}."
  type        = map(string)
  default     = {}
}

variable "public_route_table_tags" {
  description = "(Optional) A map of tags to apply to the created Public Route Table. Default is {}."
  type        = map(string)
  default     = {}
}

variable "private_route_table_tags" {
  description = "(Optional) A map of tags to apply to the created Private Route Table. Default is {}."
  type        = map(string)
  default     = {}
}

variable "intra_route_table_tags" {
  description = "(Optional) A map of tags to apply to the created Intra Route Table. Default is {}."
  type        = map(string)
  default     = {}
}

variable "nat_gateway_mode" {
  description = "(Optional) Set the mode for the NAT Gateways. Possible inputs are \"none\" (create no NAT Gateways at all), \"single\" (create a single NAT Gateway inside the first defined Public Subnet) and \"one_per_az\" (create one NAT Gateway inside the first Public Subnet in each Availability Zone). Default is \"single\"."
  type        = string
  default     = "single"
}

variable "nat_gateway_single_mode_zone" {
  description = "(Optional) Define the zone (short name) of the NAT gateway when nat_gateway_mode is \"single\" (e.g. \"a\", \"b\", or \"c\"). The AWS region will be added as a prefix. Defaults to a random zone."
  type        = string
  default     = null
}

variable "nat_gateway_tags" {
  description = "(Optional) A map of tags to apply to the created NAT Gateways. Default is {}."
  type        = map(string)
  default     = {}
}

variable "eip_tags" {
  description = "(Optional) A map of tags to apply to the created NAT Gateway Elastic IP Addresses. Default is {}."
  type        = map(string)
  default     = {}
}

variable "internet_gateway_tags" {
  description = "(Optional) A map of tags to apply to the created Internet Gateway. Default is {}."
  type        = map(string)
  default     = {}
}


# ----------------------------------------------------------------------------------------------------------------------
# MODULE CONFIGURATION PARAMETERS
# These variables are used to configure the module.
# See https://medium.com/mineiros/the-ultimate-guide-on-how-to-write-terraform-modules-part-1-81f86d31f024
# ----------------------------------------------------------------------------------------------------------------------

variable "module_enabled" {
  type        = bool
  description = "(Optional) Whether to create resources within the module or not. Default is true."
  default     = true
}

variable "module_depends_on" {
  type        = any
  description = "(Optional) A list of external resources the module depends_on. Default is []."
  default     = []
}

variable "module_tags" {
  description = "(Optional) A map of default tags to apply to all resources created which support tags. Default is {}."
  type        = map(string)
  default     = {}
}

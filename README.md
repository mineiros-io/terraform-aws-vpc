[<img src="https://raw.githubusercontent.com/mineiros-io/brand/3bffd30e8bdbbde32c143e2650b2faa55f1df3ea/mineiros-primary-logo.svg" width="400"/>](https://mineiros.io/?ref=terraform-aws-vpc)

[![Build Status](https://github.com/mineiros-io/terraform-aws-vpc/workflows/CI/CD%20Pipeline/badge.svg)](https://github.com/mineiros-io/terraform-aws-vpc/actions)
[![GitHub tag (latest SemVer)](https://img.shields.io/github/v/tag/mineiros-io/terraform-aws-vpc.svg?label=latest&sort=semver)](https://github.com/mineiros-io/terraform-aws-vpc/releases)
[![Terraform Version](https://img.shields.io/badge/terraform-1.x%20|%200.15%20|%200.14%20|%200.13%20|%200.12.20+-623CE4.svg?logo=terraform)](https://github.com/hashicorp/terraform/releases)
[![AWS Provider Version](https://img.shields.io/badge/AWS-3%20and%202.45+-F8991D.svg?logo=terraform)](https://github.com/terraform-providers/terraform-provider-aws/releases)
[![Join Slack](https://img.shields.io/badge/slack-@mineiros--community-f32752.svg?logo=slack)](https://mineiros.io/slack)

# terraform-aws-vpc

A [Terraform] base module for managing an
[Amazon Virtual Private Cloud](https://aws.amazon.com/de/vpc/) on
[Amazon Web Services (AWS)][aws].

***This module supports Terraform v0.15, v0.14, v0.13, as well as v0.12.20 and above
and is compatible with the terraform AWS provider v3 as well as v2.45 and above.***

This module is part of our Infrastructure as Code (IaC) framework
that enables our users and customers to easily deploy and manage reusable,
secure, and production-grade cloud infrastructure.


- [Module Features](#module-features)
- [Getting Started](#getting-started)
- [Module Argument Reference](#module-argument-reference)
  - [Main Resource Configuration](#main-resource-configuration)
    - [VPC](#vpc)
  - [Extended Resource Configuration](#extended-resource-configuration)
    - [Subnets](#subnets)
    - [Internet Gateway](#internet-gateway)
    - [NAT Gateways](#nat-gateways)
    - [Subnet Routing](#subnet-routing)
- [Module Configuration](#module-configuration)
- [Module Outputs](#module-outputs)
  - [Computed Attributes](#computed-attributes)
  - [Full Resource Objects](#full-resource-objects)
  - [Module Attributes](#module-attributes)
- [External Documentation](#external-documentation)
  - [AWS Documentation VPC](#aws-documentation-vpc)
  - [Terraform AWS Provider Documentation:](#terraform-aws-provider-documentation)
- [Module Versioning](#module-versioning)
  - [Backwards compatibility in `0.0.z` and `0.y.z` version](#backwards-compatibility-in-00z-and-0yz-version)
- [About Mineiros](#about-mineiros)
- [Reporting Issues](#reporting-issues)
- [Contributing](#contributing)
- [Makefile Targets](#makefile-targets)
- [License](#license)

## Module Features

This module implements the following Terraform resources

- `aws_region`
- `aws_vpc`
- `aws_subnet`
- `aws_eip`
- `aws_nat_gateway`
- `aws_route_table`
- `aws_route_table_association`
- `aws_route`
- `aws_internet_gateway`
- `aws_route_table`
- `aws_route_table_association`
- `aws_route`
- `aws_elasticache_subnet_group`
- `aws_db_subnet_group`

## Getting Started

Most basic usage just setting required arguments:

```hcl
module "terraform-aws-vpc" {
  source  = "mineiros-io/vpc/aws"
  version = "~> 0.6.0"
}
```

## Module Argument Reference

See [variables.tf] and [examples/] for details and use-cases.

### Main Resource Configuration

#### VPC

- [**`vpc_name`**](#var-vpc_name): *(Optional `string`)*<a name="var-vpc_name"></a>

  The name of the VPC. This will be used to tag resources with names
  by default.

  Default is `"main"`.

- [**`cidr_block`**](#var-cidr_block): *(Optional `string`)*<a name="var-cidr_block"></a>

  The CIDR block for the VPC.

  Default is `"10.0.0.0/16"`.

- [**`instance_tenancy`**](#var-instance_tenancy): *(Optional `string`)*<a name="var-instance_tenancy"></a>

  A tenancy option for instances launched into the VPC.
  Setting the tenancy to `dedicated` will create additional costs: See
  https://aws.amazon.com/ec2/pricing/dedicated-instances/ for details.

  Default is `"default"`.

- [**`enable_dns_support`**](#var-enable_dns_support): *(Optional `bool`)*<a name="var-enable_dns_support"></a>

  A boolean flag to enable/disable DNS support in the VPC.

  Default is `true`.

- [**`enable_dns_hostnames`**](#var-enable_dns_hostnames): *(Optional `bool`)*<a name="var-enable_dns_hostnames"></a>

  A boolean flag to enable/disable DNS hostnames in the VPC.

  Default is `false`.

- [**`enable_classiclink`**](#var-enable_classiclink): *(Optional `bool`)*<a name="var-enable_classiclink"></a>

  A boolean flag to enable/disable ClassicLink for the VPC. Only valid
  in regions and accounts that support EC2 Classic. See the
  ClassicLink documentation for more information.

  Default is `false`.

- [**`enable_classiclink_dns_support`**](#var-enable_classiclink_dns_support): *(Optional `bool`)*<a name="var-enable_classiclink_dns_support"></a>

  A boolean flag to enable/disable ClassicLink DNS Support for the
  VPC. Only valid in regions and accounts that support EC2 Classic.

  Default is `false`.

- [**`assign_generated_ipv6_cidr_block`**](#var-assign_generated_ipv6_cidr_block): *(Optional `bool`)*<a name="var-assign_generated_ipv6_cidr_block"></a>

  Requests an Amazon-provided IPv6 CIDR block with a /56 prefix length
  for the VPC. You cannot specify the range of IP addresses, or the
  size of the CIDR block.

  Default is `false`.

- [**`vpc_tags`**](#var-vpc_tags): *(Optional `string`)*<a name="var-vpc_tags"></a>

  A map of tags to assign to the vpc resource.
  To set the Name and add the capability to be used in data sources
  the `vpc_tags` will always be merged with:

  Default is `"{}"`.

  Example:

  ```hcl
  {
    Name                           = var.vpc_name
    "mineiros-io/aws/vpc/vpc-name" = var.vpc_name
  }
  ```

### Extended Resource Configuration

#### Subnets

- [**`subnets`**](#var-subnets): *(Optional `list(subnet)`)*<a name="var-subnets"></a>

  A List of `subnet` objects that defined the subnet setup within the
  VPC.

  Default is `[]`.

  Example:

  ```hcl
  subnets = [
    {
      group = "main"
      class = "public"

      map_public_ip_on_launch = true

      cidr_block = cidrsubnet("10.0.0.0/16", 4, 0)
      newbits    = 4

      netnums_by_az = {
        a = [0] # "10.0.0.0/24"
        b = [1] # "10.0.1.0/24"
      }
      tags = {}
    },
    {
      group = "main"
      class = "private"

      map_public_ip_on_launch = false

      cidr_block = cidrsubnet("10.0.0.0/16", 4, 1)
      newbits    = 4

      netnums_by_az = {
        a = [0] # "10.0.16.0/24"
        b = [1] # "10.0.17.0/24"
      }
    },
  ]
  ```

  Each `subnet` object in the list accepts the following attributes:

  - [**`group`**](#attr-subnets-group): *(Optional `string`)*<a name="attr-subnets-group"></a>

    A group name for the subnets. This can be any string. This
    information is used to group and tag resources within the subnets.
    The combination of `group` and `class` needs to be unique over all
    subnets defined. This can be changed at any time and will change
    the tags applied to resources by default.

    Default is `"main"`.

  - [**`class`**](#attr-subnets-class): *(Optional `string`)*<a name="attr-subnets-class"></a>

    The class of the subnet. This can be `"public"`, `"private"`, or
    "`intra`". This can be changed at any time and will change the
    routing of the subnet instead of recreating the subnet resource.

    - "public" defines a set of subnets where deployed components are
    reachable via the public Internet.
    - "private" defines a set of subnets where components are not
    publicly reachable but can reach the Internet.
    - "intra" defines a set of subnets that have no connectivity to
    the public Internet.

    Default is `"private"`.

  - [**`map_public_ip_on_launch`**](#attr-subnets-map_public_ip_on_launch): *(Optional `bool`)*<a name="attr-subnets-map_public_ip_on_launch"></a>

    Whether resources deployed into the subnet will be assigned a
    public IPv4 address when launched.

    Default is `true`.

  - [**`cidr_block`**](#attr-subnets-cidr_block): *(Optional `string`)*<a name="attr-subnets-cidr_block"></a>

    Define the base CIDR Block of the subnets and the parameters to
    calculate each CIDR Block.

    Default is the CIDR Block of the VPC (`cidr_block`).

  - [**`newbits`**](#attr-subnets-newbits): *(Optional `number`)*<a name="attr-subnets-newbits"></a>

    How many bits should be added when calculating the subnets CIDR
    Blocks.

    Default is `8`.

  - [**`netnums_by_az`**](#attr-subnets-netnums_by_az): *(**Required** `map(netnums_by_az)`)*<a name="attr-subnets-netnums_by_az"></a>

    Type is map(list(number)).

    A map of subnets keyed by availability zone suffix (a,b,c,d,e,f).
    The numbers define the network number with in the CIDR Block.
    See https://www.terraform.io/docs/configuration/functions/cidrsubnet.html
    for details on how this is calculated internally.

    Note: When adjusting cidr_block or newbits you might also need to
    adjust the netnums.
    The example shows how to deploy one subnet in availability zone
    `a` (`10.0.0.0/24`) and one subnet in availability zone `b`
    (`10.0.1.0/24`).

    Example:

    ```hcl
    cidr_block = "10.0.0.0/16"
    newbits    = 8

    netnums_by_az = {
      a = [0] # "10.0.0.0/24"
      b = [1] # "10.0.1.0/24"
    }
    ```

  - [**`db_subnet_group_name`**](#attr-subnets-db_subnet_group_name): *(Optional `string`)*<a name="attr-subnets-db_subnet_group_name"></a>

    The name of a db subnet group to create for all netnum ranges in
    this subnet.
    The `db_subnet_group_name` resource tags will be cloned from the
    subnets.

  - [**`elasticache_subnet_group_name`**](#attr-subnets-elasticache_subnet_group_name): *(Optional `string`)*<a name="attr-subnets-elasticache_subnet_group_name"></a>

    The name of a elasticache subnet group to create for all netnum
    ranges in this subnet.
    The `elasticache_subnet_group_name` resource tags will be cloned
    from the subnets.

  - [**`tags`**](#attr-subnets-tags): *(Optional `map(string)`)*<a name="attr-subnets-tags"></a>

    A map of tags that will be applied to each subnet in this
    group-class combination.
    Those tags will be merged with a `Name` tag, `module_tags`,
    `subnet_tags` and tags for the subnet class
    `public_subnet_tags`, `private_subnet_tags`, or
    `intra_subnet_tags`.

    To set the Name and add the capability to be used in data
    sources the `subnet_tags` will always be merged with:

    ```hcl
    {
      Name                               = "{var.vpc_name}-{subnet.group}-{subnet.class}-{az}-{idx}"
      "mineiros-io/aws/vpc/vpc-name"     = var.vpc_name
      "mineiros-io/aws/vpc/subnet-name"  = "{var.vpc_name}-{subnet.group}-{subnet.class}-{az}-{idx}"
      "mineiros-io/aws/vpc/subnet-group" = subnet.group
      "mineiros-io/aws/vpc/subnet-class" = subnet.class
    }
    ```

    Default is `{}`.

- [**`subnet_tags`**](#var-subnet_tags): *(Optional `map(string)`)*<a name="var-subnet_tags"></a>

  Tags applied to each subnet resource.

  Default is `{}`.

- [**`public_subnet_tags`**](#var-public_subnet_tags): *(Optional `map(string)`)*<a name="var-public_subnet_tags"></a>

  Tags applied to each public subnet.

  Default is `{}`.

- [**`private_subnet_tags`**](#var-private_subnet_tags): *(Optional `map(string)`)*<a name="var-private_subnet_tags"></a>

  Tags applied to each private subnet.

  Default is `{}`.

- [**`intra_subnet_tags`**](#var-intra_subnet_tags): *(Optional `map(string)`)*<a name="var-intra_subnet_tags"></a>

  Tags applied to each intra subnet.

  Default is `{}`.

#### Internet Gateway

- [**`internet_gateway_tags`**](#var-internet_gateway_tags): *(Optional `map(string)`)*<a name="var-internet_gateway_tags"></a>

  A map of tags to apply to the created Internet Gateway.
  An Internet Gateway is created if a public subnet is defined.
  All public egress and ingress traffic of all public subnets will be
  routed through the same Internet Gateway.

  To set the Name and add the capability to be used in data sources
  the `internet_gateway_tags` will always be merged with:

  ```hcl
  {
    Name                           = var.vpc_name
    "mineiros-io/aws/vpc/vpc-name" = var.vpc_name
    "mineiros-io/aws/vpc/igw-name" = var.vpc_name
  }
  ```

  Default is `{}`.

#### NAT Gateways

> **A Note on pricing:** AWS charges for each provisioned NAT
Gateway. Please see https://aws.amazon.com/vpc/pricing/ for details.
> To save costs you can use `nat_gateway_mode` to define the number
of NAT Gateways you want to deploy.
> The best practice is to deploy one NAT Gateway per Availability
Zone for higher reliability on production environments
(`one_per_az`), while you can save some costs on staging and testing
environments by deploying a single NAT Gateway (`single`).

- [**`nat_gateway_mode`**](#var-nat_gateway_mode): *(Optional `string`)*<a name="var-nat_gateway_mode"></a>

  Set the mode for the NAT Gateways. NAT Gateways will only be created
  when private subnets are defined.
  Each private subnet needs at least one configured public subnet in
  the same availability zone.
  Each NAT gateway will be assigned an Elastic IP Address.
  When changing the mode, NAT Gateways and Elastic IP Addresses will
  be created or destroyed.
  All public egress traffic of all private subnets will be routed
  through the same set of NAT Gateways.
  Possible modes are `none`, `single`, or `one_per_az`. Choose

  - `none` to create no NAT Gateways at all (use for debugging only),
  - `single` to create a single NAT Gateway inside the first defined
  Public Subnet, or
  - `one_per_az` to create one NAT Gateway inside the first Public
  Subnet in each Availability Zone.

  Default is `"single"`.

- [**`nat_gateway_tags`**](#var-nat_gateway_tags): *(Optional `map(string)`)*<a name="var-nat_gateway_tags"></a>

  A map of tags to apply to the created NAT Gateways.

  To set the Name and add the capability to be used in data sources
  the `nat_gateway_tags` will always be merged with:

  ```hcl
  {
    Name                             = "{var.vpc_name}-{each.key}"
    "mineiros-io/aws/vpc/vpc-name"   = var.vpc_name
    "mineiros-io/aws/vpc/natgw-name" = "{var.vpc_name}-{each.key}"
  }
  ```

  Default is `{}`.

- [**`eip_tags`**](#var-eip_tags): *(Optional `map(string)`)*<a name="var-eip_tags"></a>

  A map of tags to apply to the created NAT Gateway Elastic IP
  Addresses.

  To set the Name and add the capability to be used in data sources
  the `eip_tags` will always be merged with:

  ```hcl
  {
    Name                             = "{var.vpc_name}-nat-private-{each.key}"
    "mineiros-io/aws/vpc/vpc-name"   = var.vpc_name
    "mineiros-io/aws/vpc/natgw-name" = "{var.vpc_name}-{each.key}"
    "mineiros-io/aws/vpc/eip-name"   = "{var.vpc_name}-nat-private-{each.key}"
  }
  ```

  Default is `{}`.

#### Subnet Routing

- [**`route_table_tags`**](#var-route_table_tags): *(Optional `map(string)`)*<a name="var-route_table_tags"></a>

  A map of tags to apply to all created Route Tables.

  Default is `{}`.

- [**`public_route_table_tags`**](#var-public_route_table_tags): *(Optional `map(string)`)*<a name="var-public_route_table_tags"></a>

  A map of tags to apply to the created Public Route Tables.

  To set the Name and add the capability to be used in data sources
  the `public_route_table_tags` will always be merged with:

  ```hcl
  {
    Name                                   = "{var.vpc_name}-public-{each.key}"
    "mineiros-io/aws/vpc/vpc-name"         = var.vpc_name
    "mineiros-io/aws/vpc/routetable-name"  = "{var.vpc_name}-public-{each.key}"
    "mineiros-io/aws/vpc/routetable-class" = "public"
  }
  ```

  Default is `{}`.

- [**`private_route_table_tags`**](#var-private_route_table_tags): *(Optional `map(string)`)*<a name="var-private_route_table_tags"></a>

  A map of tags to apply to the created Private Route Tables.

  To set the Name and add the capability to be used in data sources
  the `private_route_table_tags` will always be merged with:

  ```hcl
  {
    Name                                   = "{var.vpc_name}-private-{each.key}"
    "mineiros-io/aws/vpc/vpc-name"         = var.vpc_name
    "mineiros-io/aws/vpc/routetable-name"  = "{var.vpc_name}-private-{each.key}"
    "mineiros-io/aws/vpc/routetable-class" = "private"
  }
  ```

  Default is `{}`.

- [**`intra_route_table_tags`**](#var-intra_route_table_tags): *(Optional `map(string)`)*<a name="var-intra_route_table_tags"></a>

  A map of tags to apply to the created Intra Route Tables.

  To set the Name and add the capability to be used in data sources
  the `intra_route_table_tags` will always be merged with:

  ```hcl
  {
    Name                                   = "{var.vpc_name}-intra-{each.key}"
    "mineiros-io/aws/vpc/vpc-name"         = var.vpc_name
    "mineiros-io/aws/vpc/routetable-name"  = "{var.vpc_name}-intra-{each.key}"
    "mineiros-io/aws/vpc/routetable-class" = "intra"
  }
  ```

  Default is `{}`.

## Module Configuration

- [**`module_enabled`**](#var-module_enabled): *(Optional `bool`)*<a name="var-module_enabled"></a>

  Specifies whether resources in the module will be created.

  Default is `true`.

- [**`module_tags`**](#var-module_tags): *(Optional `map(string)`)*<a name="var-module_tags"></a>

  A map of tags that will be applied to all created resources that
  accept tags. Tags defined with 'module_tags' can be
  overwritten by resource-specific tags.

  Default is `{}`.

- [**`module_depends_on`**](#var-module_depends_on): *(Optional `list(dependency)`)*<a name="var-module_depends_on"></a>

  A list of dependencies. Any object can be _assigned_ to this list to
  define a hidden external dependency.

## Module Outputs

The following attributes are exported by the module:

### Computed Attributes

- [**`public_subnets_by_group`**](#output-public_subnets_by_group): *(`map(public_subnets_by_group)`)*<a name="output-public_subnets_by_group"></a>

  A map of lists of public subnets keyed by group. (`aws_subnet`)

- [**`public_route_table_ids_by_group`**](#output-public_route_table_ids_by_group): *(`map(public_route_table_ids_by_group)`)*<a name="output-public_route_table_ids_by_group"></a>

  A map of lists of public route table IDs keyed by group.

- [**`public_subnet_ids_by_group`**](#output-public_subnet_ids_by_group): *(`map(public_subnet_ids_by_group)`)*<a name="output-public_subnet_ids_by_group"></a>

  A map of lists of public subnet IDs keyed by group.

- [**`private_subnets_by_group`**](#output-private_subnets_by_group): *(`map(private_subnets_by_group)`)*<a name="output-private_subnets_by_group"></a>

  A map of lists of private subnets keyed by group. (`aws_subnet`)

- [**`private_route_table_ids_by_group`**](#output-private_route_table_ids_by_group): *(`map(private_route_table_ids_by_group)`)*<a name="output-private_route_table_ids_by_group"></a>

  A map of lists of private route table IDs keyed by group.

- [**`private_subnet_ids_by_group`**](#output-private_subnet_ids_by_group): *(`map(private_subnet_ids_by_group)`)*<a name="output-private_subnet_ids_by_group"></a>

  A map of lists of private subnet IDs keyed by group.

- [**`intra_subnets_by_group`**](#output-intra_subnets_by_group): *(`map(intra_subnets_by_group)`)*<a name="output-intra_subnets_by_group"></a>

  A map of lists of intra aws_subnet keyed by group. (`aws_subnet`)

- [**`intra_route_table_ids_by_group`**](#output-intra_route_table_ids_by_group): *(`map(intra_route_table_ids_by_group)`)*<a name="output-intra_route_table_ids_by_group"></a>

  A map of lists of intra route table IDs keyed by group.

- [**`intra_subnet_ids_by_group`**](#output-intra_subnet_ids_by_group): *(`map(intra_subnet_ids_by_group)`)*<a name="output-intra_subnet_ids_by_group"></a>

  A map of lists of intra subnet IDs keyed by group.

### Full Resource Objects

- [**`vpc`**](#output-vpc): *(`object(vpc)`)*<a name="output-vpc"></a>

  The VPC. (`aws_vpc`)

- [**`intra_route_tables`**](#output-intra_route_tables): *(`map(intra_route_tables)`)*<a name="output-intra_route_tables"></a>

  A map of intra route tables keyed by group. (`aws_route_table`)

- [**`intra_route_table_associations`**](#output-intra_route_table_associations): *(`map(intra_route_table_associations)`)*<a name="output-intra_route_table_associations"></a>

  A map of intra route table associations keyed by the subnets CIDR
  Blocks. (`aws_route_table_association`)

- [**`eips`**](#output-eips): *(`map(eips)`)*<a name="output-eips"></a>

  A map of Elastic IP Adresses (EIPs) keyed by availability zone.
  (`aws_eip`)

- [**`nat_gateways`**](#output-nat_gateways): *(`map(nat_gateways)`)*<a name="output-nat_gateways"></a>

  A map of NAT gatweways keyed by availability zone.
  (`aws_nat_gateway`)

- [**`private_route_tables`**](#output-private_route_tables): *(`map(private_route_tables)`)*<a name="output-private_route_tables"></a>

  A map of private route tables keyed by group. (`aws_route_table`)

- [**`private_route_table_associations`**](#output-private_route_table_associations): *(`map(private_route_table_associations)`)*<a name="output-private_route_table_associations"></a>

  A map of private route table associations keyed by the subnets CIDR
  Blocks. (`aws_route_table_association`)

- [**`routes_to_nat_gateways`**](#output-routes_to_nat_gateways): *(`map(routes_to_nat_gateways)`)*<a name="output-routes_to_nat_gateways"></a>

  A map of routes to the NAT Gateways keyed by group. (`aws_route`)

- [**`internet_gateway`**](#output-internet_gateway): *(`object(internet_gateway)`)*<a name="output-internet_gateway"></a>

  The Internet Gateway. (`aws_internet_gateway`)

- [**`public_route_tables`**](#output-public_route_tables): *(`map(public_route_tables)`)*<a name="output-public_route_tables"></a>

  A map of public route tables keyed by group. (`aws_route_table`)

- [**`public_route_table_associations`**](#output-public_route_table_associations): *(`map(public_route_table_associations)`)*<a name="output-public_route_table_associations"></a>

  A map of public route table associations keyed by the subnets CIDR
  Blocks. (`aws_route_table_association`)

- [**`routes_to_internet_gateway`**](#output-routes_to_internet_gateway): *(`map(routes_to_internet_gateway)`)*<a name="output-routes_to_internet_gateway"></a>

  A map of routes to the Internet Gateway keyed by group. (`aws_route`)

- [**`subnets`**](#output-subnets): *(`map(subnets)`)*<a name="output-subnets"></a>

  A map of subnets keyed by CIDR Blocks. (`aws_subnet`)

### Module Attributes

- [**`module_inputs`**](#output-module_inputs): *(`map(module_inputs)`)*<a name="output-module_inputs"></a>

  A map of all module arguments. Set to the provided values or calculated default values.

- [**`module_enabled`**](#output-module_enabled): *(`bool`)*<a name="output-module_enabled"></a>

  Whether this module is enabled.

- [**`module_tags`**](#output-module_tags): *(`map(string)`)*<a name="output-module_tags"></a>

  The map of tags that are being applied to all created resources that accept tags.

## External Documentation

### AWS Documentation VPC

- https://aws.amazon.com/de/vpc/

### Terraform AWS Provider Documentation:

- https://www.terraform.io/docs/providers/aws/r/vpc.html
- https://www.terraform.io/docs/providers/aws/r/subnet.html
- https://www.terraform.io/docs/providers/aws/r/internet_gateway.html
- https://www.terraform.io/docs/providers/aws/r/nat_gateway.html
- https://www.terraform.io/docs/providers/aws/r/route_table.html
- https://www.terraform.io/docs/providers/aws/r/route_table_association.html
- https://www.terraform.io/docs/providers/aws/r/route.html

## Module Versioning

This Module follows the principles of [Semantic Versioning (SemVer)].

Given a version number `MAJOR.MINOR.PATCH`, we increment the:

1. `MAJOR` version when we make incompatible changes,
2. `MINOR` version when we add functionality in a backwards compatible manner, and
3. `PATCH` version when we make backwards compatible bug fixes.

### Backwards compatibility in `0.0.z` and `0.y.z` version

- Backwards compatibility in versions `0.0.z` is **not guaranteed** when `z` is increased. (Initial development)
- Backwards compatibility in versions `0.y.z` is **not guaranteed** when `y` is increased. (Pre-release)

## About Mineiros

[Mineiros][homepage] is a remote-first company headquartered in Berlin, Germany
that solves development, automation and security challenges in cloud infrastructure.

Our vision is to massively reduce time and overhead for teams to manage and
deploy production-grade and secure cloud infrastructure.

We offer commercial support for all of our modules and encourage you to reach out
if you have any questions or need help. Feel free to email us at [hello@mineiros.io] or join our
[Community Slack channel][slack].

## Reporting Issues

We use GitHub [Issues] to track community reported issues and missing features.

## Contributing

Contributions are always encouraged and welcome! For the process of accepting changes, we use
[Pull Requests]. If you'd like more information, please see our [Contribution Guidelines].

## Makefile Targets

This repository comes with a handy [Makefile].
Run `make help` to see details on each available target.

## License

[![license][badge-license]][apache20]

This module is licensed under the Apache License Version 2.0, January 2004.
Please see [LICENSE] for full details.

Copyright &copy; 2019-2021 [Mineiros GmbH][homepage]


<!-- References -->

[homepage]: https://mineiros.io/?ref=terraform-aws-vpc
[hello@mineiros.io]: mailto:hello@mineiros.io
[badge-build]: https://github.com/mineiros-io/terraform-aws-vpc/workflows/CI/CD%20Pipeline/badge.svg
[badge-semver]: https://img.shields.io/github/v/tag/mineiros-io/terraform-aws-vpc.svg?label=latest&sort=semver
[badge-license]: https://img.shields.io/badge/license-Apache%202.0-brightgreen.svg
[badge-terraform]: https://img.shields.io/badge/terraform-1.x%20|%200.15%20|%200.14%20|%200.13%20|%200.12.20+-623CE4.svg?logo=terraform
[badge-slack]: https://img.shields.io/badge/slack-@mineiros--community-f32752.svg?logo=slack
[build-status]: https://github.com/mineiros-io/terraform-aws-vpc/actions
[releases-github]: https://github.com/mineiros-io/terraform-aws-vpc/releases
[badge-tf-aws]: https://img.shields.io/badge/AWS-3%20and%202.45+-F8991D.svg?logo=terraform
[releases-aws-provider]: https://github.com/terraform-providers/terraform-provider-aws/releases
[releases-terraform]: https://github.com/hashicorp/terraform/releases
[apache20]: https://opensource.org/licenses/Apache-2.0
[slack]: https://join.slack.com/t/mineiros-community/shared_invite/zt-ehidestg-aLGoIENLVs6tvwJ11w9WGg
[terraform]: https://www.terraform.io
[aws]: https://aws.amazon.com/
[semantic versioning (semver)]: https://semver.org/
[variables.tf]: https://github.com/mineiros-io/terraform-aws-vpc/blob/master/variables.tf
[examples/]: https://github.com/mineiros-io/terraform-aws-vpc/blob/master/examples
[issues]: https://github.com/mineiros-io/terraform-aws-vpc/issues
[license]: https://github.com/mineiros-io/terraform-aws-vpc/blob/master/LICENSE
[makefile]: https://github.com/mineiros-io/terraform-aws-vpc/blob/master/Makefile
[pull requests]: https://github.com/mineiros-io/terraform-aws-vpc/pulls
[contribution guidelines]: https://github.com/mineiros-io/terraform-aws-vpc/blob/master/CONTRIBUTING.md

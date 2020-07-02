[<img src="https://raw.githubusercontent.com/mineiros-io/brand/3bffd30e8bdbbde32c143e2650b2faa55f1df3ea/mineiros-primary-logo.svg" width="400"/>][homepage]

[![Build Status][badge-build]][build-status]
[![GitHub tag (latest SemVer)][badge-semver]][releases-github]
[![license][badge-license]][apache20]
[![Terraform Version][badge-terraform]][releases-terraform]
[![Join Slack][badge-slack]][slack]

# terraform-aws-vpc

A [Terraform] base module for [Amazon Web Services (AWS)][AWS].

This module is part of our Infrastructure as Code (IaC) framework
that enables our users and customers to easily deploy and manage reusable,
secure, and production-grade cloud infrastructure.

- [Module Features](#module-features)
- [Getting Started](#getting-started)
- [Module Argument Reference](#module-argument-reference)
  - [Top-level Arguments](#top-level-arguments)
    - [Module Configuration](#module-configuration)
    - [Main Resource Configuration](#main-resource-configuration)
    - [Extended Resource Configuration](#extended-resource-configuration)
- [Module Attributes Reference](#module-attributes-reference)
- [External Documentation](#external-documentation)
- [Module Versioning](#module-versioning)
  - [Backwards compatibility in `0.0.z` and `0.y.z` version](#backwards-compatibility-in-00z-and-0yz-version)
- [About Mineiros](#about-mineiros)
- [Reporting Issues](#reporting-issues)
- [Contributing](#contributing)
- [Makefile Targets](#makefile-targets)
- [License](#license)

## Module Features

In contrast to the plain `aws_vpc` resource this module creates a full networking stack including subnets, gateways and basic routing.
Additional features can be enabled on demand.

- **Standard Module Features**:
  Cool Feature of the main resource, tags

- **Extended Module Features**:
  Awesome Extended Feature of an additional related resource,
  and another Cool Feature

- **Additional Features**:
  a Cool Feature that is not actually a resource but a cool set up from us

- *Features not yet implemented*:
  Standard Features missing,
  Extended Features planned,
  Additional Features planned

## Getting Started

Most basic usage just setting required arguments:

```hcl
module "terraform-aws-vpc" {
  source  = "mineiros-io/vpc/aws"
  version = "0.1.0"
}
```

## Module Argument Reference

See [variables.tf] and [examples/] for details and use-cases.

### Top-level Arguments

#### Module Configuration

- **`module_enabled`**: *(Optional `bool`)*

  Specifies whether resources in the module will be created.
  Default is `true`.

- **`module_tags`**: *(Optional `map(string)`)*

  A map of tags that will be applied to all created resources that accept tags. Tags defined with 'module_tags' can be
  overwritten by resource-specific tags.
  Default is `{}`.

- **`module_depends_on`**: *(Optional `list(dependencies)`)*

  A list of dependencies. Any object can be _assigned_ to this list to define a hidden external dependency.

#### Main Resource Configuration

##### VPC

- **`vpc_name`**: *(Required `string`)*

  The Name of the VPC. This will be used to tag resources with Names by default.
  Default is `"main"`.

- **`cidr_block`**: *(Required `string`)*

  The CIDR block for the VPC.
  Default is `"10.0.0.0/16"`.

- **`instance_tenancy`**: *(Optional `string`)*

  A tenancy option for instances launched into the VPC
  Default is `"default"`.

- **`enable_dns_support`**: *(Optional `bool`)*

  A boolean flag to enable/disable DNS support in the VPC.
  Default is `true`.

- **`enable_dns_hostnames`**: *(Optional `bool`)*

  A boolean flag to enable/disable DNS hostnames in the VPC.
  Default is `false`.

- **`enable_classiclink`**: *(Optional `bool`)*

  A boolean flag to enable/disable ClassicLink for the VPC. Only valid in regions and accounts that support EC2 Classic. See the ClassicLink documentation for more information.
  Default is `false`.

- **`enable_classiclink_dns_support`**: *(Optional `bool`)*

  A boolean flag to enable/disable ClassicLink DNS Support for the VPC. Only valid in regions and accounts that support EC2 Classic.
  Default is `false`.

- **`assign_generated_ipv6_cidr_block`**: *(Optional `bool`)*

  Requests an Amazon-provided IPv6 CIDR block with a /56 prefix length for the VPC. You cannot specify the range of IP addresses, or the size of the CIDR block.
  Default is `false`.

- **`vpc_tags`**: *(Optional `string`)*

  A map of tags to assign to the vpc resource.
  Will be merged with `{ Name = var.vpc_name }` to set the name.
  Default is `{}`.

#### Extended Resource Configuration

##### Subnets

- **`subnets`**: *(Optional `list(subnets)`)*

  A List of subnet objects that defined the subnet setup within the VPC.
  Default is `[]`.

  ```
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

      cidr_block = cidrsubnet(local.cidr_block, 4, 1)
      newbits    = 4

      netnums_by_az = {
        a = [0] # "10.0.16.0/24"
        b = [1] # "10.0.17.0/24"
      }
    },
  ]
  ```

- **`subnet_tags`**: *(Optional `map(string)`)*

  Tags applied to each subnet resource.
  Default is `{}`.

- **`public_subnet_tags`**: *(Optional `map(string)`)*

  Tags applied to each public subnet.
  Default is `{}`.

- **`private_subnet_tags`**: *(Optional `map(string)`)*

  Tags applied to each private subnet.
  Default is `{}`.

- **`intra_subnet_tags`**: *(Optional `map(string)`)*

  Tags applied to each intra subnet.
  Default is `{}`.

###### [`subnets`](#extended-resource-configuration) Object Arguments

- **`group`**: *(Optional `string`)*

  A group name for the subnets. This can be any string. This information is used to group and tag resources within the subnets.
  The combination of `group` and `class` needs to be unique over all subnets defined.
  This can be changed at any time and will change the tags applied to resources by default.
  Default is `"main"`.

- **`class`**: *(Optional `string`)*

  The class of the subnet. This can be `"public"`, `"private"`, or "`intra`".
  This can be changed at any time and will change the routing of the subnet instead of recreating the subnet resource.

  - "public" defines a set of subnets where deployed components are reachable via the public Internet.
  - "private" defines a set of subnets where components are not publicly reachable but can reach the Internet.
  - "intra" defines a set of subnets that have no connectivity to the public Internet.

  Default is `"private"`.

- **`map_public_ip_on_launch`**: *(Optional `bool`)*

  Whether resources deployed into the subnet will be assigned a public IPv4 address when launched.
  Default is `true` when subnet class is `public`, `false` otherwise.

- **`cidr_block`**: *(Optional `string`)*

  Define the base CIDR Block of the subnets and the parameters to calculate each CIDR Block.
  Default is the CIDR Block of the VPC (`cidr_block`).

- **`newbits`**: *(Optional `number`)*

  How many bits should be added when calculating the subnets CIDR Blocks.
  Default is `8`.

- **`netnums_by_az`**: **(Required `map(list(number)`)**

  A map of subnets keyed by availability zone suffix (a,b,c,d,e,f).
  The numbers define the network number with in the CIDR Block.
  See https://www.terraform.io/docs/configuration/functions/cidrsubnet.html for details on how this is calculated internally.

  Note: When adjusting cidr_block or newbits you might also need to adjust the netnums.
  The example shows how to deploy one subnet in availability zone "a" ("10.0.0.0/24") and one subnet in availability zone "b" ("10.0.1.0/24").

  ```
  cidr_block = "10.0.0.0/16"
  newbits    = 8

  netnums_by_az = {
    a = [0] # "10.0.0.0/24"
    b = [1] # "10.0.1.0/24"
  }
  ```

- **`tags`**: *(Optional `map(string`)*

  A map of tags that will be applied to each subnet in this group-class combination.
  Those tags will be merged with a `Name` tag, `module_tags`, `subnet_tags` and tags for the subnet class `public_subnet_tags`, `private_subnet_tags`, or `intra_subnet_tags`.
  Default is `{}`.

##### Internet Gateway

- **`internet_gateway_tags`**: *(Optional `map(string)`)*

  A map of tags to apply to the created Internet Gateway.
  An Internet Gateway is created if a public subnet is defined.
  All public egress and ingress traffic of all public subnets will be routed through the same Internet Gateway.
  Default is `{}`.

##### NAT Gateways

- **`nat_gateway_mode`**: *(Optional `string`)*

  Set the mode for the NAT Gateways. NAT Gateways will only be created when private subnets are defined.
  Each private subnet needs at least one configured public subnet in the same availability zone.
  Each NAT gateway will be assigned an Elastic IP Address.
  When changing the mode, NAT Gateways and Elastic IP Addresses will be created or destroyed.
  All public egress traffic of all private subnets will be routed through the same set of NAT Gateways.
  Possible modes are `none`, `single`, or `one_per_az`. Choose

  - `none` to create no NAT Gateways at all (use for debugging only),
  - `single` to create a single NAT Gateway inside the first defined Public Subnet, or
  - `one_per_az` to create one NAT Gateway inside the first Public Subnet in each Availability Zone.

  Default is `"single"`.

- **`nat_gateway_tags`**: *(Optional `map(string)`)*

  A map of tags to apply to the created NAT Gateways.
  Default is `{}`.

- **`eip_tags`**: *(Optional `map(string)`)*

  A map of tags to apply to the created NAT Gateway Elastic IP Addresses.
  Default is `{}`.

##### Subnet Routing

- **`route_table_tags`**: *(Optional `map(string)`)*

  A map of tags to apply to all created Route Tables.
  Default is `{}`.

- **`public_route_table_tags`**: *(Optional `map(string)`)*

  A map of tags to apply to the created Public Route Tables.
  Default is `{}`.

- **`private_route_table_tags`**: *(Optional `map(string)`)*

  A map of tags to apply to the created Private Route Tables.
  Default is `{}`.

- **`intra_route_table_tags`**: *(Optional `map(string)`)*

  A map of tags to apply to the created Intra Route Tables.
  Default is `{}`.

## Module Attributes Reference

The following attributes are exported by the module:

- **`public_subnets_by_group`**

  A map of lists of public subnets keyed by group. (`aws_subnet`)

- **`public_route_table_ids_by_group`**

  A map of lists of public route table IDs keyed by group.

- **`public_subnet_ids_by_group`**

  A map of lists of public subnet IDs keyed by group.

- **`private_subnets_by_group`**

  A map of lists of private subnets keyed by group. (`aws_subnet`)

- **`private_route_table_ids_by_group`**

  A map of lists of private route table IDs keyed by group.

- **`private_subnet_ids_by_group`**

  A map of lists of private subnet IDs keyed by group.

- **`intra_subnets_by_group`**

  A map of lists of intra aws_subnet keyed by group. (`aws_subnet`)

- **`intra_route_table_ids_by_group`**

  A map of lists of intra route table IDs keyed by group.

- **`intra_subnet_ids_by_group`**

  A map of lists of intra subnet IDs keyed by group.

- **`vpc`**

  The VPC. (aws_vpc)

- **`intra_route_tables`**

  A map of intra route tables keyed by group. (`aws_route_table`)

- **`intra_route_table_associations`**

  A map of intra route table associations keyed by the subnets CIDR Blocks. (`aws_route_table_association`)

- **`eips`**

  A map of Elastic IP Adresses (EIPs) keyed by availability zone. (`aws_eip`)

- **`nat_gateways`**

  A map of NAT gatweways keyed by availability zone. (`aws_nat_gateway`)

- **`private_route_tables`**

  A map of private route tables keyed by group. (`aws_route_table`)

- **`private_route_table_associations`**

  A map of private route table associations keyed by the subnets CIDR Blocks. (`aws_route_table_association`)

- **`routes_to_nat_gateways`**

  A map of routes to the NAT Gateways keyed by group. (`aws_route`)

- **`internet_gateway`**

  The Internet Gateway. (`aws_internet_gateway`)

- **`public_route_tables`**

  A map of public route tables keyed by group. (`aws_route_table`)

- **`public_route_table_associations`**

  A map of public route table associations keyed by the subnets CIDR Blocks. (`aws_route_table_association`)

- **`routes_to_internet_gateway`**

  A map of routes to the Internet Gateway keyed by group. (`aws_route`)

- **`subnets`**

  A map of subnets keyed by CIDR Blocks. (`aws_subnet`)

- **`module_inputs`**

  A map of all module arguments. Set to the provided values or calculated default values.

- **`module_enabled`**

  Whether this module is enabled.

- **`module_tags`**

  The map of tags that are being applied to all created resources that accept tags.

## External Documentation

- AWS Documentation IAM:
  - Roles: https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles.html
  - Policies: https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_policies.html
  - Instance Profile: https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_use_switch-role-ec2_instance-profiles.html

- Terraform AWS Provider Documentation:
  - https://www.terraform.io/docs/providers/aws/r/iam_role.html
  - https://www.terraform.io/docs/providers/aws/r/iam_role_policy.html
  - https://www.terraform.io/docs/providers/aws/r/iam_role_policy_attachment.html
  - https://www.terraform.io/docs/providers/aws/r/iam_instance_profile.html

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

This module is licensed under the Apache License Version 2.0, January 2004.
Please see [LICENSE] for full details.

Copyright &copy; 2020 [Mineiros GmbH][homepage]

<!-- References -->

[homepage]: https://mineiros.io/?ref=terraform-aws-vpc
[hello@mineiros.io]: mailto:hello@mineiros.io

[badge-build]: https://mineiros.semaphoreci.com/badges/terraform-aws-vpc/branches/master.svg?style=shields&key=df11a416-f581-4d35-917a-fa3c2de2048e
[badge-semver]: https://img.shields.io/github/v/tag/mineiros-io/terraform-aws-vpc.svg?label=latest&sort=semver
[badge-license]: https://img.shields.io/badge/license-Apache%202.0-brightgreen.svg
[badge-terraform]: https://img.shields.io/badge/terraform-0.13%20and%200.12.20+-623CE4.svg?logo=terraform
[badge-slack]: https://img.shields.io/badge/slack-@mineiros--community-f32752.svg?logo=slack

[build-status]: https://mineiros.semaphoreci.com/projects/terraform-aws-vpc
[releases-github]: https://github.com/mineiros-io/terraform-aws-vpc/releases

[releases-terraform]: https://github.com/hashicorp/terraform/releases
[apache20]: https://opensource.org/licenses/Apache-2.0
[slack]: https://join.slack.com/t/mineiros-community/shared_invite/zt-ehidestg-aLGoIENLVs6tvwJ11w9WGg
[Terraform]: https://www.terraform.io
[AWS]: https://aws.amazon.com/
[Semantic Versioning (SemVer)]: https://semver.org/

[variables.tf]: https://github.com/mineiros-io/terraform-aws-vpc/blob/master/variables.tf
[examples/]: https://github.com/mineiros-io/terraform-aws-vpc/blob/master/examples
[Issues]: https://github.com/mineiros-io/terraform-aws-vpc/issues
[LICENSE]: https://github.com/mineiros-io/terraform-aws-vpc/blob/master/LICENSE
[Makefile]: https://github.com/mineiros-io/terraform-aws-vpc/blob/master/Makefile
[Pull Requests]: https://github.com/mineiros-io/terraform-aws-vpc/pulls
[Contribution Guidelines]: https://github.com/mineiros-io/terraform-aws-vpc/blob/master/CONTRIBUTING.md

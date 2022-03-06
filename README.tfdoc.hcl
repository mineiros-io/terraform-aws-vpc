header {
  image = "https://raw.githubusercontent.com/mineiros-io/brand/3bffd30e8bdbbde32c143e2650b2faa55f1df3ea/mineiros-primary-logo.svg"
  url   = "https://mineiros.io/?ref=terraform-aws-vpc"

  badge "build" {
    image = "https://github.com/mineiros-io/terraform-aws-vpc/workflows/CI/CD%20Pipeline/badge.svg"
    url   = "https://github.com/mineiros-io/terraform-aws-vpc/actions"
    text  = "Build Status"
  }

  badge "semver" {
    image = "https://img.shields.io/github/v/tag/mineiros-io/terraform-aws-vpc.svg?label=latest&sort=semver"
    url   = "https://github.com/mineiros-io/terraform-aws-vpc/releases"
    text  = "GitHub tag (latest SemVer)"
  }

  badge "terraform" {
    image = "https://img.shields.io/badge/terraform-1.x%20|%200.15%20|%200.14%20|%200.13%20|%200.12.20+-623CE4.svg?logo=terraform"
    url   = "https://github.com/hashicorp/terraform/releases"
    text  = "Terraform Version"
  }

  badge "tf-aws-provider" {
    image = "https://img.shields.io/badge/AWS-3%20and%202.45+-F8991D.svg?logo=terraform"
    url   = "https://github.com/terraform-providers/terraform-provider-aws/releases"
    text  = "AWS Provider Version"
  }

  badge "slack" {
    image = "https://img.shields.io/badge/slack-@mineiros--community-f32752.svg?logo=slack"
    url   = "https://mineiros.io/slack"
    text  = "Join Slack"
  }
}

section {
  title   = "terraform-aws-vpc"
  toc     = true
  content = <<-END
    A [Terraform] base module for managing an
    [Amazon Virtual Private Cloud](https://aws.amazon.com/de/vpc/) on
    [Amazon Web Services (AWS)][aws].

    ***This module supports Terraform v0.15, v0.14, v0.13, as well as v0.12.20 and above
    and is compatible with the terraform AWS provider v3 as well as v2.45 and above.***

    This module is part of our Infrastructure as Code (IaC) framework
    that enables our users and customers to easily deploy and manage reusable,
    secure, and production-grade cloud infrastructure.
  END

  section {
    title   = "Module Features"
    content = <<-END
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
    END
  }

  section {
    title   = "Getting Started"
    content = <<-END
      Most basic usage just setting required arguments:

      ```hcl
      module "terraform-aws-vpc" {
        source  = "git@github.com:mineiros-io/terraform-aws-vpc.git?ref=v0.6.0"
      }
      ```
    END
  }

  section {
    title   = "Module Argument Reference"
    content = <<-END
      See [variables.tf] and [examples/] for details and use-cases.
    END

    section {
      title = "Main Resource Configuration"

      section {
        title = "VPC"

        variable "vpc_name" {
          type        = string
          default     = "main"
          description = <<-END
            The name of the VPC. This will be used to tag resources with names
            by default.
          END
        }

        variable "cidr_block" {
          type        = string
          default     = "10.0.0.0/16"
          description = <<-END
            The CIDR block for the VPC.
          END
        }

        variable "instance_tenancy" {
          type        = string
          default     = "default"
          description = <<-END
            A tenancy option for instances launched into the VPC.
            Setting the tenancy to `dedicated` will create additional costs: See
            https://aws.amazon.com/ec2/pricing/dedicated-instances/ for details.
          END
        }

        variable "enable_dns_support" {
          type        = bool
          default     = true
          description = <<-END
            A boolean flag to enable/disable DNS support in the VPC.
          END
        }

        variable "enable_dns_hostnames" {
          type        = bool
          default     = false
          description = <<-END
            A boolean flag to enable/disable DNS hostnames in the VPC.
          END
        }

        variable "enable_classiclink" {
          type        = bool
          default     = false
          description = <<-END
            A boolean flag to enable/disable ClassicLink for the VPC. Only valid
            in regions and accounts that support EC2 Classic. See the
            ClassicLink documentation for more information.
          END
        }

        variable "enable_classiclink_dns_support" {
          type        = bool
          default     = false
          description = <<-END
            A boolean flag to enable/disable ClassicLink DNS Support for the
            VPC. Only valid in regions and accounts that support EC2 Classic.
          END
        }

        variable "assign_generated_ipv6_cidr_block" {
          type        = bool
          default     = false
          description = <<-END
            Requests an Amazon-provided IPv6 CIDR block with a /56 prefix length
            for the VPC. You cannot specify the range of IP addresses, or the
            size of the CIDR block.
          END
        }

        variable "vpc_tags" {
          type           = string
          default        = "{}"
          description    = <<-END
            A map of tags to assign to the vpc resource.
            To set the Name and add the capability to be used in data sources
            the `vpc_tags` will always be merged with:
          END
          readme_example = <<-END
            {
              Name                           = "{vpc_name}"
              "mineiros-io/aws/vpc/vpc-name" = "{vpc_name}"
            }
          END
        }
      }
    }

    section {
      title = "Extended Resource Configuration"

      section {
        title = "Subnets"

        variable "subnets" {
          type           = list(subnet)
          default        = []
          description    = <<-END
            A List of `subnet` objects that defined the subnet setup within the
            VPC.
          END
          readme_example = <<-END
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
          END

          attribute "group" {
            type        = string
            default     = "main"
            description = <<-END
              A group name for the subnets. This can be any string. This
              information is used to group and tag resources within the subnets.
              The combination of `group` and `class` needs to be unique over all
              subnets defined. This can be changed at any time and will change
              the tags applied to resources by default.
            END
          }

          attribute "class" {
            type        = string
            default     = "private"
            description = <<-END
              The class of the subnet. This can be `"public"`, `"private"`, or
              "`intra`". This can be changed at any time and will change the
              routing of the subnet instead of recreating the subnet resource.

              - "public" defines a set of subnets where deployed components are
              reachable via the public Internet.
              - "private" defines a set of subnets where components are not
              publicly reachable but can reach the Internet.
              - "intra" defines a set of subnets that have no connectivity to
              the public Internet.
            END
          }

          attribute "map_public_ip_on_launch" {
            type        = bool
            default     = true
            description = <<-END
              Whether resources deployed into the subnet will be assigned a
              public IPv4 address when launched.
            END
          }

          attribute "cidr_block" {
            type        = string
            description = <<-END
              Define the base CIDR Block of the subnets and the parameters to
              calculate each CIDR Block.

              Default is the CIDR Block of the VPC (`cidr_block`).
            END
          }

          attribute "newbits" {
            type        = number
            default     = 8
            description = <<-END
              How many bits should be added when calculating the subnets CIDR
              Blocks.
            END
          }

          attribute "netnums_by_az" {
            required       = true
            type           = map(netnums_by_az)
            description    = <<-END
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
            END
            readme_example = <<-END
              cidr_block = "10.0.0.0/16"
              newbits    = 8

              netnums_by_az = {
                a = [0] # "10.0.0.0/24"
                b = [1] # "10.0.1.0/24"
              }
            END
          }

          attribute "db_subnet_group_name" {
            type        = string
            description = <<-END
              The name of a db subnet group to create for all netnum ranges in
              this subnet.
              The `db_subnet_group_name` resource tags will be cloned from the
              subnets.
            END
          }

          attribute "elasticache_subnet_group_name" {
            type        = string
            description = <<-END
              The name of a elasticache subnet group to create for all netnum
              ranges in this subnet.
              The `elasticache_subnet_group_name` resource tags will be cloned
              from the subnets.
            END
          }

          attribute "tags" {
            type        = map(string)
            default     = {}
            description = <<-END
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
                Name                               = "{vpc_name}-{subnet.group}-{subnet.class}-{az}-{idx}"
                "mineiros-io/aws/vpc/vpc-name"     = "{vpc_name}"
                "mineiros-io/aws/vpc/subnet-name"  = "{vpc_name}-{subnet.group}-{subnet.class}-{az}-{idx}"
                "mineiros-io/aws/vpc/subnet-group" = "{subnet.group}"
                "mineiros-io/aws/vpc/subnet-class" = "{subnet.class}"
              }
              ```
            END
          }
        }

        variable "subnet_tags" {
          type        = map(string)
          default     = {}
          description = <<-END
            Tags applied to each subnet resource.
          END
        }

        variable "public_subnet_tags" {
          type        = map(string)
          default     = {}
          description = <<-END
            Tags applied to each public subnet.
          END
        }

        variable "private_subnet_tags" {
          type        = map(string)
          default     = {}
          description = <<-END
            Tags applied to each private subnet.
          END
        }

        variable "intra_subnet_tags" {
          type        = map(string)
          default     = {}
          description = <<-END
            Tags applied to each intra subnet.
          END
        }
      }

      section {
        title = "Internet Gateway"

        variable "internet_gateway_tags" {
          type        = map(string)
          default     = {}
          description = <<-END
            A map of tags to apply to the created Internet Gateway.
            An Internet Gateway is created if a public subnet is defined.
            All public egress and ingress traffic of all public subnets will be
            routed through the same Internet Gateway.

            To set the Name and add the capability to be used in data sources
            the `internet_gateway_tags` will always be merged with:

            ```hcl
            {
              Name                           = "{vpc_name}"
              "mineiros-io/aws/vpc/vpc-name" = "{vpc_name}"
              "mineiros-io/aws/vpc/igw-name" = "{vpc_name}"
            }
            ```
          END
        }
      }

      section {
        title   = "NAT Gateways"
        content = <<-END
          > **A Note on pricing:** AWS charges for each provisioned NAT
          Gateway. Please see https://aws.amazon.com/vpc/pricing/ for details.
          > To save costs you can use `nat_gateway_mode` to define the number
          of NAT Gateways you want to deploy.
          > The best practice is to deploy one NAT Gateway per Availability
          Zone for higher reliability on production environments
          (`one_per_az`), while you can save some costs on staging and testing
          environments by deploying a single NAT Gateway (`single`).
        END

        variable "nat_gateway_mode" {
          type        = string
          default     = "single"
          description = <<-END
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

            - `"none"` to create no NAT Gateways at all (use for debugging only),
            - `"single"` to create a single NAT Gateway inside the first defined
            Public Subnet, or
            - `"one_per_az"` to create one NAT Gateway inside the first Public
            Subnet in each Availability Zone.
          END
        }

        variable "nat_gateway_single_mode_zone" {
          type        = string
          default     = "a random zone"
          description = <<-END
            Define the zone (short name) of the NAT gateway when nat_gateway_mode is "single" (e.g. "a", "b", or "c").
            The AWS region will be added as a prefix.
          END
        }

        variable "nat_gateway_tags" {
          type        = map(string)
          default     = {}
          description = <<-END
            A map of tags to apply to the created NAT Gateways.

            To set the Name and add the capability to be used in data sources
            the `nat_gateway_tags` will always be merged with:

            ```hcl
            {
              Name                             = "{vpc_name}-{zone}"
              "mineiros-io/aws/vpc/vpc-name"   = "{vpc_name}"
              "mineiros-io/aws/vpc/natgw-name" = "{vpc_name}-{zone}"
            }
            ```
          END
        }

        variable "eip_tags" {
          type        = map(string)
          default     = {}
          description = <<-END
            A map of tags to apply to the created NAT Gateway Elastic IP
            Addresses.

            To set the Name and add the capability to be used in data sources
            the `eip_tags` will always be merged with:

            ```hcl
            {
              Name                             = "{vpc_name}-nat-private-{zone}"
              "mineiros-io/aws/vpc/vpc-name"   = "{vpc_name}"
              "mineiros-io/aws/vpc/natgw-name" = "{vpc_name}-{zone}"
              "mineiros-io/aws/vpc/eip-name"   = "{vpc_name}-nat-private-{zone}"
            }
            ```
          END
        }
      }

      section {
        title = "Subnet Routing"

        variable "route_table_tags" {
          type        = map(string)
          default     = {}
          description = <<-END
            A map of tags to apply to all created Route Tables.
          END
        }

        variable "public_route_table_tags" {
          type        = map(string)
          default     = {}
          description = <<-END
            A map of tags to apply to the created Public Route Tables.

            To set the Name and add the capability to be used in data sources
            the `public_route_table_tags` will always be merged with:

            ```hcl
            {
              Name                                   = "{vpc_name}-public-{group}"
              "mineiros-io/aws/vpc/vpc-name"         = "{vpc_name}"
              "mineiros-io/aws/vpc/routetable-name"  = "{vpc_name}-public-{group}"
              "mineiros-io/aws/vpc/routetable-class" = "public"
            }
            ```
          END
        }

        variable "private_route_table_tags" {
          type        = map(string)
          default     = {}
          description = <<-END
            A map of tags to apply to the created Private Route Tables.

            To set the Name and add the capability to be used in data sources
            the `private_route_table_tags` will always be merged with:

            ```hcl
            {
              Name                                   = "{vpc_name}-private-{group}-{zone}"
              "mineiros-io/aws/vpc/vpc-name"         = "{vpc_name}"
              "mineiros-io/aws/vpc/routetable-name"  = "{vpc_name}-private-{group}-{zone}"
              "mineiros-io/aws/vpc/routetable-class" = "private"
            }
            ```
          END
        }

        variable "intra_route_table_tags" {
          type        = map(string)
          default     = {}
          description = <<-END
            A map of tags to apply to the created Intra Route Tables.

            To set the Name and add the capability to be used in data sources
            the `intra_route_table_tags` will always be merged with:

            ```hcl
            {
              Name                                   = "{vpc_name}-intra-{group}"
              "mineiros-io/aws/vpc/vpc-name"         = "{vpc_name}"
              "mineiros-io/aws/vpc/routetable-name"  = "{vpc_name}-intra-{group}"
              "mineiros-io/aws/vpc/routetable-class" = "intra"
            }
            ```
          END
        }
      }
    }
  }

  section {
    title = "Module Configuration"

    variable "module_enabled" {
      type        = bool
      default     = true
      description = <<-END
        Specifies whether resources in the module will be created.
      END
    }

    variable "module_tags" {
      type        = map(string)
      default     = {}
      description = <<-END
        A map of tags that will be applied to all created resources that
        accept tags. Tags defined with 'module_tags' can be
        overwritten by resource-specific tags.
      END
    }

    variable "module_depends_on" {
      type        = list(dependency)
      description = <<-END
        A list of dependencies. Any object can be _assigned_ to this list to
        define a hidden external dependency.
      END
    }
  }

  section {
    title   = "Module Outputs"
    content = <<-END
      The following attributes are exported by the module:
    END

    section {
      title = "Computed Attributes"

      output "public_subnets_by_group" {
        type        = map(public_subnets_by_group)
        description = <<-END
          A map of lists of public subnets keyed by group. (`aws_subnet`)
        END
      }

      output "public_route_table_ids_by_group" {
        type        = map(public_route_table_ids_by_group)
        description = <<-END
          A map of lists of public route table IDs keyed by group.
        END
      }

      output "public_subnet_ids_by_group" {
        type        = map(public_subnet_ids_by_group)
        description = <<-END
          A map of lists of public subnet IDs keyed by group.
        END
      }

      output "private_subnets_by_group" {
        type        = map(private_subnets_by_group)
        description = <<-END
          A map of lists of private subnets keyed by group. (`aws_subnet`)
        END
      }

      output "private_route_table_ids_by_group" {
        type        = map(private_route_table_ids_by_group)
        description = <<-END
          A map of lists of private route table IDs keyed by group.
        END
      }

      output "private_subnet_ids_by_group" {
        type        = map(private_subnet_ids_by_group)
        description = <<-END
          A map of lists of private subnet IDs keyed by group.
        END
      }

      output "intra_subnets_by_group" {
        type        = map(intra_subnets_by_group)
        description = <<-END
          A map of lists of intra aws_subnet keyed by group. (`aws_subnet`)
        END
      }

      output "intra_route_table_ids_by_group" {
        type        = map(intra_route_table_ids_by_group)
        description = <<-END
          A map of lists of intra route table IDs keyed by group.
        END
      }

      output "intra_subnet_ids_by_group" {
        type        = map(intra_subnet_ids_by_group)
        description = <<-END
          A map of lists of intra subnet IDs keyed by group.
        END
      }
    }

    section {
      title = "Full Resource Objects"

      output "vpc" {
        type        = object(vpc)
        description = <<-END
          The VPC. (`aws_vpc`)
        END
      }

      output "intra_route_tables" {
        type        = map(intra_route_tables)
        description = <<-END
          A map of intra route tables keyed by group. (`aws_route_table`)
        END
      }

      output "intra_route_table_associations" {
        type        = map(intra_route_table_associations)
        description = <<-END
          A map of intra route table associations keyed by the subnets CIDR
          Blocks. (`aws_route_table_association`)
        END
      }

      output "eips" {
        type        = map(eips)
        description = <<-END
          A map of Elastic IP Adresses (EIPs) keyed by availability zone.
          (`aws_eip`)
        END
      }

      output "nat_gateways" {
        type        = map(nat_gateways)
        description = <<-END
          A map of NAT gatweways keyed by availability zone.
          (`aws_nat_gateway`)
        END
      }

      output "private_route_tables" {
        type        = map(private_route_tables)
        description = <<-END
          A map of private route tables keyed by group. (`aws_route_table`)
        END
      }

      output "private_route_table_associations" {
        type        = map(private_route_table_associations)
        description = <<-END
          A map of private route table associations keyed by the subnets CIDR
          Blocks. (`aws_route_table_association`)
        END
      }

      output "routes_to_nat_gateways" {
        type        = map(routes_to_nat_gateways)
        description = <<-END
          A map of routes to the NAT Gateways keyed by group. (`aws_route`)
        END
      }

      output "internet_gateway" {
        type        = object(internet_gateway)
        description = <<-END
          The Internet Gateway. (`aws_internet_gateway`)
        END
      }

      output "public_route_tables" {
        type        = map(public_route_tables)
        description = <<-END
          A map of public route tables keyed by group. (`aws_route_table`)
        END
      }

      output "public_route_table_associations" {
        type        = map(public_route_table_associations)
        description = <<-END
          A map of public route table associations keyed by the subnets CIDR
          Blocks. (`aws_route_table_association`)
        END
      }

      output "routes_to_internet_gateway" {
        type        = map(routes_to_internet_gateway)
        description = <<-END
          A map of routes to the Internet Gateway keyed by group. (`aws_route`)
        END
      }

      output "subnets" {
        type        = map(subnets)
        description = <<-END
          A map of subnets keyed by CIDR Blocks. (`aws_subnet`)
        END
      }
    }

    section {
      title = "Module Attributes"

      output "module_inputs" {
        type        = map(module_inputs)
        description = <<-END
          A map of all module arguments. Set to the provided values or calculated default values.
        END
      }

      output "module_enabled" {
        type        = bool
        description = <<-END
          Whether this module is enabled.
        END
      }

      output "module_tags" {
        type        = map(string)
        description = <<-END
          The map of tags that are being applied to all created resources that accept tags.
        END
      }
    }
  }

  section {
    title = "External Documentation"

    section {
      title   = "AWS Documentation VPC"
      content = <<-END
        - https://aws.amazon.com/de/vpc/
      END
    }

    section {
      title   = "Terraform AWS Provider Documentation:"
      content = <<-END
        - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc
        - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet
        - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway
        - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway
        - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table
        - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association
        - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route
      END
    }
  }

  section {
    title   = "Module Versioning"
    content = <<-END
      This Module follows the principles of [Semantic Versioning (SemVer)].

      Given a version number `MAJOR.MINOR.PATCH`, we increment the:

      1. `MAJOR` version when we make incompatible changes,
      2. `MINOR` version when we add functionality in a backwards compatible manner, and
      3. `PATCH` version when we make backwards compatible bug fixes.
    END

    section {
      title   = "Backwards compatibility in `0.0.z` and `0.y.z` version"
      content = <<-END
        - Backwards compatibility in versions `0.0.z` is **not guaranteed** when `z` is increased. (Initial development)
        - Backwards compatibility in versions `0.y.z` is **not guaranteed** when `y` is increased. (Pre-release)
      END
    }
  }

  section {
    title   = "About Mineiros"
    content = <<-END
      [Mineiros][homepage] is a remote-first company headquartered in Berlin, Germany
      that solves development, automation and security challenges in cloud infrastructure.

      Our vision is to massively reduce time and overhead for teams to manage and
      deploy production-grade and secure cloud infrastructure.

      We offer commercial support for all of our modules and encourage you to reach out
      if you have any questions or need help. Feel free to email us at [hello@mineiros.io] or join our
      [Community Slack channel][slack].
    END
  }

  section {
    title   = "Reporting Issues"
    content = <<-END
      We use GitHub [Issues] to track community reported issues and missing features.
    END
  }

  section {
    title   = "Contributing"
    content = <<-END
      Contributions are always encouraged and welcome! For the process of accepting changes, we use
      [Pull Requests]. If you'd like more information, please see our [Contribution Guidelines].
    END
  }

  section {
    title   = "Makefile Targets"
    content = <<-END
      This repository comes with a handy [Makefile].
      Run `make help` to see details on each available target.
    END
  }

  section {
    title   = "License"
    content = <<-END
      [![license][badge-license]][apache20]

      This module is licensed under the Apache License Version 2.0, January 2004.
      Please see [LICENSE] for full details.

      Copyright &copy; 2019-2022 [Mineiros GmbH][homepage]
    END
  }
}

references {
  ref "homepage" {
    value = "https://mineiros.io/?ref=terraform-aws-vpc"
  }
  ref "hello@mineiros.io" {
    value = "mailto:hello@mineiros.io"
  }
  ref "badge-build" {
    value = "https://github.com/mineiros-io/terraform-aws-vpc/workflows/CI/CD%20Pipeline/badge.svg"
  }
  ref "badge-semver" {
    value = "https://img.shields.io/github/v/tag/mineiros-io/terraform-aws-vpc.svg?label=latest&sort=semver"
  }
  ref "badge-license" {
    value = "https://img.shields.io/badge/license-Apache%202.0-brightgreen.svg"
  }
  ref "badge-terraform" {
    value = "https://img.shields.io/badge/terraform-1.x%20|%200.15%20|%200.14%20|%200.13%20|%200.12.20+-623CE4.svg?logo=terraform"
  }
  ref "badge-slack" {
    value = "https://img.shields.io/badge/slack-@mineiros--community-f32752.svg?logo=slack"
  }
  ref "build-status" {
    value = "https://github.com/mineiros-io/terraform-aws-vpc/actions"
  }
  ref "releases-github" {
    value = "https://github.com/mineiros-io/terraform-aws-vpc/releases"
  }
  ref "badge-tf-aws" {
    value = "https://img.shields.io/badge/AWS-3%20and%202.45+-F8991D.svg?logo=terraform"
  }
  ref "releases-aws-provider" {
    value = "https://github.com/terraform-providers/terraform-provider-aws/releases"
  }
  ref "releases-terraform" {
    value = "https://github.com/hashicorp/terraform/releases"
  }
  ref "apache20" {
    value = "https://opensource.org/licenses/Apache-2.0"
  }
  ref "slack" {
    value = "https://join.slack.com/t/mineiros-community/shared_invite/zt-ehidestg-aLGoIENLVs6tvwJ11w9WGg"
  }
  ref "terraform" {
    value = "https://www.terraform.io"
  }
  ref "aws" {
    value = "https://aws.amazon.com/"
  }
  ref "semantic versioning (semver)" {
    value = "https://semver.org/"
  }
  ref "variables.tf" {
    value = "https://github.com/mineiros-io/terraform-aws-vpc/blob/master/variables.tf"
  }
  ref "examples/" {
    value = "https://github.com/mineiros-io/terraform-aws-vpc/blob/master/examples"
  }
  ref "issues" {
    value = "https://github.com/mineiros-io/terraform-aws-vpc/issues"
  }
  ref "license" {
    value = "https://github.com/mineiros-io/terraform-aws-vpc/blob/master/LICENSE"
  }
  ref "makefile" {
    value = "https://github.com/mineiros-io/terraform-aws-vpc/blob/master/Makefile"
  }
  ref "pull requests" {
    value = "https://github.com/mineiros-io/terraform-aws-vpc/pulls"
  }
  ref "contribution guidelines" {
    value = "https://github.com/mineiros-io/terraform-aws-vpc/blob/master/CONTRIBUTING.md"
  }
}

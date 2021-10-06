# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.6.0]

### Added

- Add tags for easier data-sourcing
- Add support for elasticache subnet groups

## [0.5.0]

### Added

- Add support for db subnet groups
- Add support terraform `v1.x`

## [0.4.0]

### Added

- Add terraform `v0.15` support

## [0.3.0]

### BREAKING CHANGES

- updating will recreate routes to nat gateways using a new resource key as terraform address

### Added

- Add support for terraform `v0.14`

### Fixed

- BREAKING: Fix terraform route modification behavior when switching nat_gateway_mode

## [0.2.0]

### Added

- Add support for Terraform AWS Provider v3.x
- Add support for Terraform v0.13.x
- Prepare support for Terraform v0.14.x

## [0.1.0] - 2020-07-06

### Added

- THIS RELEASE IS BREAKING BACKWARD COMPATIBILITY.
- Add support to move subnets between subnet classes without recreation (public, private, intra).
- Add CHANGELOG.md, CONTIBUTING.md and test/README.md.
- Add new input variables to support dynamic subnets.
- Ensure cidr_blocks are align to network address.
- Document all input arguments and output attributes.
- Add minimal and module_enabled tests

### Changed

- THIS RELEASE IS BREAKING BACKWARD COMPATIBILITY.
- Refactor the full module while keeping the same basic feature set.
- Refactor test to deploy VPC with all NAT gateway Modes (single, one_per_az, none).
- Update build-system.

### Removed

- THIS RELEASE IS BREAKING BACKWARD COMPATIBILITY.
- Remove routing to the internet from subnets of class 'intra'.
- Remove flags to allow and disallow internet access for private and intra subnets.
- Remove support for static network classes.
- Remove most input variables related to defining subnets.

## [0.0.3] - 2020-06-20

### Changed

- Update build-system
- Update documentation

### Fixed

- Set tenancy to "default"
- Instance tenancy defaulted to "dedicated" which is very costly when running instances in the VPC for non production workloads on scale. If you used v0.0.1 or v0.0.2 please check that you did not start any dedicated instances and review your costs and recreate any started instances to run on shared hardware with default tenenacy. Note: Those are still pre-releases and not meant to run workloads yet.

### Removed

- Unpublish v0.0.1 and v0.0.2 due to expensive dedicated tenancy

## [0.0.2] - 2020-06-04

### Changed

- Update build-system
- Update documentation

## [0.0.1] - 2020-02-17

### Added

- Add support for three subnet classes (public, private, intra)
- Add support for multiple NAT gateway modes (none, single, one_per_az)
- Implement support for `aws_vpc` resource
- Implement support for `aws_subnet` resource
- Implement support for `aws_route_table` resource
- Implement support for `aws_route_table_association` resource
- Implement support for `aws_route` resource
- Implement support for `aws_internet_gateway` resource
- Implement support for `aws_eip` resource
- Implement support for `aws_nat_gateway` resource
- Document the usage of the module in README.md
- Document the usage of examples
- Add unit tests for basic use cases

<!-- markdown-link-check-disable -->

[unreleased]: https://github.com/mineiros-io/terraform-aws-vpc/compare/v0.6.0...HEAD
[0.6.0]: https://github.com/mineiros-io/terraform-aws-vpc/compare/v0.5.0...v0.6.0

<!-- markdown-link-check-enable -->

[0.5.0]: https://github.com/mineiros-io/terraform-aws-vpc/compare/v0.4.0...v0.5.0
[0.4.0]: https://github.com/mineiros-io/terraform-aws-vpc/compare/v0.3.0...v0.4.0
[0.3.0]: https://github.com/mineiros-io/terraform-aws-vpc/compare/v0.2.0...v0.3.0
[0.2.0]: https://github.com/mineiros-io/terraform-aws-vpc/compare/v0.1.0...v0.2.0
[0.1.0]: https://github.com/mineiros-io/terraform-aws-vpc/compare/v0.0.3...v0.1.0
[0.0.3]: https://github.com/mineiros-io/terraform-aws-vpc/compare/55347bd0db3b37ad2d2bcebdf11ed1ea666ad788...v0.0.3
[0.0.2]: https://github.com/mineiros-io/terraform-aws-vpc/compare/0608a9123de5d1c02a6fcd0a2ee8e4f5216c1a49...55347bd0db3b37ad2d2bcebdf11ed1ea666ad788
[0.0.1]: https://github.com/mineiros-io/terraform-aws-vpc/commit/0608a9123de5d1c02a6fcd0a2ee8e4f5216c1a49

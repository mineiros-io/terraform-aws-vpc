[<img src="https://raw.githubusercontent.com/mineiros-io/brand/master/mineiros-primary-logo.svg" width="400"/>](https://www.mineiros.io/?ref=terraform-aws-vpc)

[![Build Status](https://mineiros.semaphoreci.com/badges/terraform-aws-vpc/branches/master.svg?style=shields)](https://mineiros.semaphoreci.com/projects/terraform-aws-vpc)
[![GitHub tag (latest SemVer)](https://img.shields.io/github/v/tag/mineiros-io/terraform-aws-vpc.svg?label=latest&sort=semver)](https://github.com/mineiros-io/terraform-aws-vpc/releases)
[![license](https://img.shields.io/badge/license-Apache%202.0-brightgreen.svg)](https://opensource.org/licenses/Apache-2.0)
[![Terraform Version](https://img.shields.io/badge/terraform-~%3E%200.12.20-623CE4.svg)](https://github.com/hashicorp/terraform/releases)
[<img src="https://img.shields.io/badge/slack-@mineiros--community-f32752.svg?logo=slack">](https://join.slack.com/t/mineiros-community/shared_invite/zt-ehidestg-aLGoIENLVs6tvwJ11w9WGg)

# terraform-aws-vpc

A [Terraform](https://www.terraform.io) 0.12 module to create a
[Virtual Private Cloud (VPC)](https://aws.amazon.com/vpc/) on
[Amazon Web Services (AWS)](https://aws.amazon.com/).


## Makefile Targets

This repository comes with a handy
[Makefile](https://github.com/mineiros-io/terraform-aws-vpc/blob/master/Makefile).
Run `make help` to see details on each available target.

## Module Versioning

This Module follows the principles of [Semantic Versioning (SemVer)](https://semver.org/).

Using the given version number of `MAJOR.MINOR.PATCH`, we apply the following constructs:

1. Use the `MAJOR` version for incompatible changes.
1. Use the `MINOR` version when adding functionality in a backwards compatible manner.
1. Use the `PATCH` version when introducing backwards compatible bug fixes.

### Backwards compatibility in `0.0.z` and `0.y.z` version

- In the context of initial development, backwards compatibility in versions `0.0.z` is **not guaranteed** when `z` is
  increased. (Initial development)
- In the context of pre-release, backwards compatibility in versions `0.y.z` is **not guaranteed** when `y` is
  increased. (Pre-release)

## About Mineiros

Mineiros is a [DevOps as a Service](https://mineiros.io/?ref=terraform-aws-vpc) company based in Berlin, Germany. We offer commercial support
for all of our projects and encourage you to reach out if you have any questions or need help.
Feel free to send us an email at [hello@mineiros.io](mailto:hello@mineiros.io).

We can also help you with:

- Terraform modules for all types of infrastructure such as VPCs, Docker clusters, databases, logging and monitoring, CI, etc.
- Consulting & training on AWS, Terraform and DevOps

## Reporting Issues

We use GitHub [Issues](https://github.com/mineiros-io/terraform-aws-vpc/issues)
to track community reported issues and missing features.

## Contributing

Contributions are always encouraged and welcome! For the process of accepting changes, we use
[Pull Requests](https://github.com/mineiros-io/terraform-aws-vpc/pulls). If you'd like more information, please
see our [Contribution Guidelines](https://github.com/mineiros-io/terraform-aws-vpc/blob/master/CONTRIBUTING.md).

## Makefile Targets

This repository comes with a handy
[Makefile](https://github.com/mineiros-io/terraform-aws-vpc/blob/master/Makefile).
Run `make help` to see details on each available target.

## License

This module is licensed under the Apache License Version 2.0, January 2004.
Please see [LICENSE](https://github.com/mineiros-io/terraform-aws-vpc/blob/master/LICENSE) for full details.

Copyright &copy; 2020 Mineiros GmbH

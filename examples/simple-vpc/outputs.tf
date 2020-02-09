output "public_subnets_list" {
  value = module.vpc.public_subnets_list
}

output "vpc" {
  value = module.vpc.full_vpc
}

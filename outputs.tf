output "public_subnets_list" {
  value = local.public_subnets
}

output "full_vpc" {
  description = "The full VPC object."
  value       = try(aws_vpc.vpc[0], {})
}

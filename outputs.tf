//output "public_subnets_list" {
//  value = local.public_subnets
//}

output "public_subnets_list" {
  value = var.public_subnets
}

//output "filtered_list" {
//  value = data.aws_availability_zones.filtered_list
//}

output "vpc" {
  value = aws_vpc.vpc
}

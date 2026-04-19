output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnets" {
  value = module.vpc.public_subnets
}

output "private_subnets" {
  value = module.vpc.private_subnets
}

output "ec2_public_ip" {
  value = module.ec2.public_ip
}

output "rds_endpoint" {
  value = module.rds.endpoint
}

output "vpc_id" {
  description = "ID da VPC criada"
  value       = module.vpc.vpc_id  
}

output "subnet-servico" {
  description = "Subnet Servico"
  value       = module.vpc.private_subnets[index(var.vpc-vpn.private-subnet-names, "AWS_SERVICO")]  
}


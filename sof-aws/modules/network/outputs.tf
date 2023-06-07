output "subnet-servico" {
  description = "Subnet Servico"
  value       = module.vpc.private_subnets[index(var.vpc-vpn.private-subnet-names, "AWS_SERVICO")]  
}


module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "~> 3.19.0"

  name = "VPC_TESTE"
  cidr = "10.0.0.0/16"

  azs = ["${var.aws_region}a", "${var.aws_region}b", "${var.aws_region}c"]

  private_subnets      = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  private_subnet_names = ["Teste-Servico", "Teste-Outro-Servico", "Teste-terceiro-servico"]

  public_subnets      = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  public_subnet_names = ["DMZ01", "DMZ02", "DMZ03"]

  enable_nat_gateway = false
  enable_vpn_gateway = false

  tags = {
    Terraform   = "true"
    Environment = "sof-aws-teste"
  }
}


module "nat" {
  source = "int128/nat-instance/aws"
  version = "~> 2.1.0"

  enabled                     = true
  name                        = "nat-instance"
  vpc_id                      = module.vpc.vpc_id
  public_subnet               = module.vpc.public_subnets[0]
  private_subnets_cidr_blocks = module.vpc.private_subnets_cidr_blocks
  private_route_table_ids     = module.vpc.private_route_table_ids
  use_spot_instance           = false
  instance_types              = ["t3.small"]
  tags = {
    Terraform   = "true"
    Environment = "sof-aws-teste"
  }
}

resource "aws_eip" "nat" {
  network_interface = module.nat.eni_id
  tags = {
    Name        = "nat-instance-sof"
    Terraform   = "true"
    Environment = "sof-aws-teste"
  }
}
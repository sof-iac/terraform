module "vpn_gateway" {
  source  = "terraform-aws-modules/vpn-gateway/aws"
  version = "~> 2.0"

  vpc_id              = module.vpc.vpc_id
  vpn_gateway_id      = module.vpc.vgw_id
  customer_gateway_id = module.vpc.cgw_ids[0]

  # precalculated length of module variable vpc_subnet_route_table_ids
  vpc_subnet_route_table_count = length(module.vpc.private_route_table_ids)
  vpc_subnet_route_table_ids   = module.vpc.private_route_table_ids

  vpn_connection_static_routes_only         = true
  vpn_connection_static_routes_destinations = ["10.209.68.0/24", "172.27.1.0/24", "172.27.3.0/24", "192.168.20.0/24", "192.168.22.0/24", "192.168.250.0/23"]

  tags = {
    "Name"        = "VPN_AWS_SOF"
    "Terraform"   = "true"
    "Environment" = "sof-aws-prod"
  }
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name                 = "VPC_SOF"
  cidr                 = "10.100.0.0/16"
  enable_dns_hostnames = true

  vpc_tags = {
    "Name"        = "VPC_SOF"
  }

  azs                  = ["sa-east-1a"]
  private_subnets      = ["10.100.64.0/20", "10.100.16.0/20", "10.100.0.0/20", "10.100.32.0/20", "10.100.48.0/20"]
  private_subnet_names = ["AWS_SERVICO", "AWS_DOM_RECURSO", "AWS_DMZ", "AWS_GERENCIA", "AWS_KUBERNETES"]
  propagate_private_route_tables_vgw = true

  public_subnets      = ["10.100.254.0/24"]
  public_subnet_names = ["AWS_PUBLIC"]
  propagate_public_route_tables_vgw = true
  
  manage_default_route_table           = true
  
  create_igw = true

  igw_tags = {
    "Name"        = "AWS_INTGW01"
    "Terraform"   = "true"
    "Environment" = "sof-aws-prod"
  }

  enable_nat_gateway = false

  enable_vpn_gateway = true

  vpn_gateway_tags = {
    "Name"        = "sof-vpg"
    "Terraform"   = "true"
    "Environment" = "sof-aws-prod"
  }

  customer_gateways = {
    sof-onpremise = {
      bgp_asn     = 65000
      ip_address  = "177.15.130.226"
    }
  }

  customer_gateway_tags = {
    "Name"        = "sof-onpremise"
    "Terraform"   = "true"
    "Environment" = "sof-aws-prod"
  }

  tags = {
    "Terraform"   = "true"
    "Environment" = "sof-aws-prod"
  }
}

module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  name = "AWS_NATGW01"

  ami                    = "ami-047992932eb72e310"
  instance_type          = "t3.small"
  key_name               = "user_svc_aws_inicial"
  ebs_optimized          = true
  vpc_security_group_ids = ["sg-04b9eb53336ae176b"]
  subnet_id              = module.vpc.public_subnets[0]
  source_dest_check      = false
  
  tags = {
    Terraform   = "true"
    Environment = "sof-aws-prod"
  }
}

resource "aws_eip" "natgw_eip" {
  network_interface = module.ec2_instance.primary_network_interface_id
  vpc      = true

  tags = {
    Name        = "eip_aws_natgw01"
    Terraform   = "true"
    Environment = "sof-aws-prod"
  }
}

resource "aws_route" "natgw_routes" {

  route_table_id         = module.vpc.private_route_table_ids[count.index]
  destination_cidr_block = "0.0.0.0/0"
  #instance_id            = "i-028d4db9ddfc774dd"
  network_interface_id   = module.ec2_instance.primary_network_interface_id
  count                  = length(module.vpc.private_route_table_ids)
}
module "vpn_gateway" {
  source  = "terraform-aws-modules/vpn-gateway/aws"
  version = "~> 2.0"

  vpc_id              = module.vpc.vpc_id
  vpn_gateway_id      = module.vpc.vgw_id
  customer_gateway_id = module.vpc.cgw_ids[0]

  # precalculated length of module variable vpc_subnet_route_table_ids
  vpc_subnet_route_table_count = length(module.vpc.private_route_table_ids)
  vpc_subnet_route_table_ids   = module.vpc.private_route_table_ids

  vpn_connection_static_routes_only         = true
  vpn_connection_static_routes_destinations = ["10.209.68.0/24", "172.27.1.0/24", "172.27.3.0/24", "192.168.20.0/24", "192.168.22.0/24", "192.168.250.0/23"]

  tags = {
    "Name"        = "VPN_AWS_SOF"
    "Terraform"   = "true"
    "Environment" = "sof-aws-prod"
  }
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name                 = "VPC_SOF"
  cidr                 = "10.100.0.0/16"
  enable_dns_hostnames = true

  vpc_tags = {
    "Name"        = "VPC_SOF"
  }

  azs                  = ["sa-east-1a"]
  private_subnets      = ["10.100.64.0/20", "10.100.16.0/20", "10.100.0.0/20", "10.100.32.0/20", "10.100.48.0/20"]
  private_subnet_names = ["AWS_SERVICO", "AWS_DOM_RECURSO", "AWS_DMZ", "AWS_GERENCIA", "AWS_KUBERNETES"]
  propagate_private_route_tables_vgw = true

  public_subnets      = ["10.100.254.0/24"]
  public_subnet_names = ["AWS_PUBLIC"]
  propagate_public_route_tables_vgw = true
  
  manage_default_route_table           = true
  
  create_igw = true

  igw_tags = {
    "Name"        = "AWS_INTGW01"
    "Terraform"   = "true"
    "Environment" = "sof-aws-prod"
  }

  enable_nat_gateway = false

  enable_vpn_gateway = true

  vpn_gateway_tags = {
    "Name"        = "sof-vpg"
    "Terraform"   = "true"
    "Environment" = "sof-aws-prod"
  }

  customer_gateways = {
    sof-onpremise = {
      bgp_asn     = 65000
      ip_address  = "177.15.130.226"
    }
  }

  customer_gateway_tags = {
    "Name"        = "sof-onpremise"
    "Terraform"   = "true"
    "Environment" = "sof-aws-prod"
  }

  tags = {
    "Terraform"   = "true"
    "Environment" = "sof-aws-prod"
  }
}

module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  name = "AWS_NATGW01"

  ami                    = "ami-047992932eb72e310"
  instance_type          = "t3.small"
  key_name               = "user_svc_aws_inicial"
  ebs_optimized          = true
  vpc_security_group_ids = ["sg-04b9eb53336ae176b"]
  subnet_id              = module.vpc.public_subnets[0]
  source_dest_check      = false
  
  tags = {
    Terraform   = "true"
    Environment = "sof-aws-prod"
  }
}

resource "aws_eip" "natgw_eip" {
  network_interface = module.ec2_instance.primary_network_interface_id
  vpc      = true

  tags = {
    Name        = "eip_aws_natgw01"
    Terraform   = "true"
    Environment = "sof-aws-prod"
  }
}

resource "aws_route" "natgw_routes" {

  route_table_id         = module.vpc.private_route_table_ids[count.index]
  destination_cidr_block = "0.0.0.0/0"
  network_interface_id   = module.ec2_instance.primary_network_interface_id
  count                  = length(module.vpc.private_route_table_ids)
}

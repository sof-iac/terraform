module "vpn_gateway" {
  source  = "terraform-aws-modules/vpn-gateway/aws"
  version = "~> 2.0"

  vpc_id                  = module.vpc.vpc_id
  vpn_gateway_id          = module.vpc.vgw_id
  customer_gateway_id     = module.vpc.cgw_ids[0]

  # precalculated length of module variable vpc_subnet_route_table_ids
  vpc_subnet_route_table_count = 3
  vpc_subnet_route_table_ids   = module.vpc.private_route_table_ids

  vpn_connection_static_routes_only = true
  vpn_connection_static_routes_destinations = ["10.209.68.0/24","172.27.1.0/24","172.27.3.0/24","192.168.20.0/24","192.168.22.0/24","192.168.250.0/23"]
  
  tags = {
    "Name" = "VPN_AWS_SOF"
    "Terraform" = "true"
    "Environment" = "sof-aws-prod"
  }
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  cidr = "10.100.0.0/16"
  enable_dns_hostnames = true

  vpc_tags = {
    "Name" = "VPC_SOF"
    "Terraform" = "true"
    "Environment" = "sof-aws-prod"
  }
  
  azs                  = ["sa-east-1a"]
  private_subnets      = ["10.100.64.0/20", "10.100.16.0/20", "10.100.0.0/20","10.100.32.0/20","10.100.48.0/20"]
  private_subnet_names = ["AWS_SERVICO", "AWS_DOM_RECURSO", "AWS_DMZ","AWS_GERENCIA","AWS_KUBERNETES"]

  public_subnets      = ["10.100.254.0/24"]
  public_subnet_names = ["AWS_PUBLIC"]

  manage_default_route_table = true
  default_route_table_name = "tab_rotas_subredes_privadas"
  default_route_table_propagating_vgws = [module.vpc.vgw_id]
  default_route_table_routes = [
    {
      cidr_block            = "0.0.0.0/0"
      instance_id           = "i-028d4db9ddfc774dd"
      network_interface_id  = "eni-056b97e553dfc448f"
    },
    {
      cidr_block = "10.209.68.0/24"
      gateway_id = module.vpc.vgw_id
    },
    {
      cidr_block = "172.27.1.0/24"
      gateway_id = module.vpc.vgw_id
    },
    {
      cidr_block = "172.27.3.0/24"
      gateway_id = module.vpc.vgw_id
    },
    {
      cidr_block = "192.168.20.0/24"
      gateway_id = module.vpc.vgw_id
    },
    {
      cidr_block = "192.168.22.0/24"
      gateway_id = module.vpc.vgw_id
    },
    {
      cidr_block = "192.168.250.0/23"
      gateway_id = module.vpc.vgw_id
    }
  ]
 
  create_igw = true

  igw_tags = {
    "Name" = "AWS_INTGW01"
    "Terraform" = "true"
    "Environment" = "sof-aws-prod"
  }

  enable_nat_gateway = false

  enable_vpn_gateway = true

  vpn_gateway_tags = {
    "Name" = "sof-vpg"
    "Terraform" = "true"
    "Environment" = "sof-aws-prod"
  }

  customer_gateways = {
    sof-onpremise = {
      bgp_asn    = 65000
      ip_address = "177.15.130.226"
    }
  }

  customer_gateway_tags = {
    "Name" = "sof-onpremise"
    "Terraform" = "true"
    "Environment" = "sof-aws-prod"
  }
}
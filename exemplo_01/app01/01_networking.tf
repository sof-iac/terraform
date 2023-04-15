module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  count = length(var.vpc-vpn-sof)

  name                 = var.vpc-vpn-sof[count.index].vpc-name
  cidr                 = var.vpc-vpn-sof[count.index].vpc-cidr
  enable_dns_hostnames = true

  vpc_tags = {"Name" = var.vpc-vpn-sof[count.index].vpc-name}

  azs                                = var.vpc-vpn-sof[count.index].vpc-azs
  private_subnets                    = var.vpc-vpn-sof[count.index].private-subnets
  private_subnet_names               = var.vpc-vpn-sof[count.index].private-subnet-names
  propagate_private_route_tables_vgw = true

  public_subnets                    = var.vpc-vpn-sof[count.index].public-subnets
  public_subnet_names               = var.vpc-vpn-sof[count.index].public-subnet-names
  propagate_public_route_tables_vgw = true
  
  manage_default_route_table = true
  
  create_igw = true

  igw_tags = {"Name" = var.vpc-vpn-sof[count.index].igw-name}

  enable_nat_gateway = false

  enable_vpn_gateway = true

  vpn_gateway_tags = {"Name" = var.vpc-vpn-sof[count.index].vpg-name}

  customer_gateways = {
    (var.cgw-sof.cgw-name) = {
      bgp_asn     = var.cgw-sof.bgp-asn
      ip_address  = var.cgw-sof.ip
    }
  }

  customer_gateway_tags = {
    "Name"        = var.cgw-sof.cgw-name
    "Environment" = var.cgw-sof.env
    "Terraform"   = "true"    
  }

  tags = {
    "Environment" = var.vpc-vpn-sof[count.index].env
    "Terraform"   = "true"
  }
}

module "vpn_gateway" {
  source  = "terraform-aws-modules/vpn-gateway/aws"
  version = "~> 2.0"

  count = length(var.vpc-vpn-sof)

  vpc_id              = module.vpc[count.index].vpc_id
  vpn_gateway_id      = module.vpc[count.index].vgw_id
  customer_gateway_id = module.vpc[count.index].cgw_ids[0]

  vpc_subnet_route_table_count = length(module.vpc[count.index].private_route_table_ids)
  vpc_subnet_route_table_ids   = module.vpc[count.index].private_route_table_ids

  vpn_connection_static_routes_only         = true
  vpn_connection_static_routes_destinations = var.vpc-vpn-sof[count.index].vpn-routes

  tags = {
    "Name"        = var.vpc-vpn-sof[count.index].vpn-name
    "Environment" = var.vpc-vpn-sof[count.index].env
    "Terraform"   = "true"    
  }
}

module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  count = length(var.natgw-instance-sof)

  name = var.natgw-instance-sof[count.index].instance-name

  ami                    = var.natgw-instance-sof[count.index].ami
  instance_type          = var.natgw-instance-sof[count.index].type
  key_name               = var.natgw-instance-sof[count.index].access-key-name
  ebs_optimized          = true
  vpc_security_group_ids = var.natgw-instance-sof[count.index].vpc-security-groups
  subnet_id              = module.vpc[count.index].public_subnets[0]
  source_dest_check      = false    #Deve ser setado para false para NAT
  
  tags = {
    Environment = var.natgw-instance-sof[count.index].env
    Terraform   = "true"
  }
}

resource "aws_eip" "natgw_eip" {

  count = length(module.ec2_instance)

  network_interface = module.ec2_instance[count.index].primary_network_interface_id
  vpc      = true

  tags = {
    Name        = "eip_${var.natgw-instance-sof[count.index].instance-name}"
    Environment = var.natgw-instance-sof[count.index].env
    Terraform   = "true"    
  }
}

resource "aws_route" "natgw_routes" {

  count = length(module.vpc[0].private_route_table_ids)

  route_table_id         = module.vpc[0].private_route_table_ids[count.index]
  destination_cidr_block = "0.0.0.0/0"
  network_interface_id   = module.ec2_instance[0].primary_network_interface_id
  
}

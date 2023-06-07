module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name                 = var.vpc-vpn.vpc-name
  cidr                 = var.vpc-vpn.vpc-cidr
  enable_dns_hostnames = true

  vpc_tags = {"Name" = var.vpc-vpn.vpc-name}

  azs                                = var.vpc-vpn.vpc-azs
  private_subnets                    = var.vpc-vpn.private-subnets-cidr
  private_subnet_names               = var.vpc-vpn.private-subnet-names
  propagate_private_route_tables_vgw = true

  public_subnets                    = var.vpc-vpn.public-subnets-cidr
  public_subnet_names               = var.vpc-vpn.public-subnet-names
  propagate_public_route_tables_vgw = true
  
  manage_default_route_table = true
  
  create_igw = true

  igw_tags = {"Name" = var.vpc-vpn.igw-name}

  enable_nat_gateway = false

  enable_vpn_gateway = true

  vpn_gateway_tags = {"Name" = var.vpc-vpn.vpg-name}

  customer_gateways = {
    (var.cgw.cgw-name) = {
      bgp_asn     = var.cgw.bgp-asn
      ip_address  = var.cgw.ip
    }
  }

  customer_gateway_tags = {
    "Name"        = var.cgw.cgw-name
    "Environment" = var.cgw.env
    "Terraform"   = "true"    
  }

  tags = {
    "Environment" = var.vpc-vpn.env
    "Terraform"   = "true"
  }
}

module "vpn_gateway" {
  source  = "terraform-aws-modules/vpn-gateway/aws"
  version = "~> 2.0"

  vpc_id              = module.vpc.vpc_id
  vpn_gateway_id      = module.vpc.vgw_id
  customer_gateway_id = module.vpc.cgw_ids[0]

  vpc_subnet_route_table_count = length(module.vpc.private_route_table_ids)
  vpc_subnet_route_table_ids   = module.vpc.private_route_table_ids

  vpn_connection_static_routes_only         = true
  vpn_connection_static_routes_destinations = var.vpc-vpn.vpn-routes

  tags = {
    "Name"        = var.vpc-vpn.vpn-name
    "Environment" = var.vpc-vpn.env
    "Terraform"   = "true"
  }
}

module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  name = var.natgw-instance.instance-name

  ami                    = var.natgw-instance.ami
  instance_type          = var.natgw-instance.type
  key_name               = var.natgw-instance.access-key-name
  ebs_optimized          = true
  vpc_security_group_ids = var.natgw-instance.vpc-security-groups
  subnet_id              = module.vpc.public_subnets[0]
  source_dest_check      = false    #Deve ser setado para false para NAT
  
  tags = {
    "Environment" = var.natgw-instance.env
    "Terraform"   = "true"
  }
}

resource "aws_eip" "natgw_eip" {

  network_interface = module.ec2_instance.primary_network_interface_id
  domain            = "vpc"

  tags = {
    Name        = "eip_${var.natgw-instance.instance-name}"
    Environment = var.natgw-instance.env
    Terraform   = "true"    
  }
}

resource "aws_route" "natgw_routes" {

  count = length(module.vpc.private_route_table_ids)

  route_table_id         = module.vpc.private_route_table_ids[count.index]
  destination_cidr_block = "0.0.0.0/0"
  network_interface_id   = module.ec2_instance.primary_network_interface_id
}

 module "zones" {
  source  = "terraform-aws-modules/route53/aws//modules/zones"
  version = "~> 2.0"

  zones = {
    "aws.sof.remoto" = {
      comment = "Managed by Terraform"

       vpc = [{
        vpc_id     = "vpc-036d6cf078bef8017"
        vpc_region = "sa-east-1"
      }]

      tags = {
        "Name"        = "aws.sof.remoto"
        "Environment" = "sof-aws-prod"
        "Type"        = "private.domain"
      }
    }
  }

  tags = {
    "Terraform"   = "true"
  }
}

 module "records" {
  source  = "terraform-aws-modules/route53/aws//modules/records"
  version = "~> 2.0"

  zone_id = values(module.zones.route53_zone_zone_id)[0]

  records = [
    {
      name    = ""
      type    = "NS"
      ttl     = 172800
      records = ["ns-0.awsdns-00.com.", "ns-1024.awsdns-00.org.", "ns-1536.awsdns-00.co.uk.", "ns-512.awsdns-00.net."]
    },
    {
      name    = ""
      type    = "SOA"
      ttl     = 900
      records = ["ns-1536.awsdns-00.co.uk. awsdns-hostmaster.amazon.com. 1 7200 900 1209600 86400"]
    },
    {
      name    = "aws_natgw01"
      type    = "A"
      ttl     = 300
      records = ["10.100.254.166"]
    },
    {
      name    = "aws_pshi01"
      type    = "A"
      ttl     = 300
      records = ["10.100.67.240"]
    }
  ]

  depends_on = [module.zones]
}
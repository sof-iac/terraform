include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../modules/network"
}
  inputs = {
    cgw = {
        cgw-name = "sof-onpremise"
        env      = "sof-aws-prod"
        bgp-asn  = 65000
        ip       = "177.15.130.226"
    }

    vpc-vpn = {
        vpc-name             = "VPC_SOF"
        vpc-cidr             = "10.100.0.0/16"
        vpc-azs              = ["sa-east-1a"]
        private-subnets-cidr = ["10.100.64.0/20", "10.100.16.0/20", "10.100.0.0/20", "10.100.32.0/20", "10.100.48.0/20"]
        private-subnet-names = ["AWS_SERVICO", "AWS_DOM_RECURSO", "AWS_DMZ", "AWS_GERENCIA", "AWS_KUBERNETES"]
        public-subnets-cidr  = ["10.100.254.0/24"]
        public-subnet-names  = ["AWS_PUBLIC"]
        igw-name             = "AWS_INTGW01"
        vpg-name             = "sof-vpg"


        vpn-name   = "VPN_AWS_SOF"
        vpn-routes = ["10.209.68.0/24", "172.27.1.0/24", "172.27.3.0/24", "192.168.20.0/24", "192.168.22.0/24", "192.168.250.0/23"]

        env = "sof-aws-prod"
    }

    natgw-instance  = {
        instance-name       = "aws_natgw01"
        ami                 = "ami-047992932eb72e310"
        type                = "t3.small"
        access-key-name     = "user_svc_aws_inicial"
        vpc-security-groups = ["sg-04b9eb53336ae176b"]
        env                 = "sof-aws-prod"
    }
    
}
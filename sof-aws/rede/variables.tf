variable cgw-sof {
  type = object(
    {
      cgw-name = string
      env      = string
      bgp-asn  = number
      ip       = string
    }
  )

  default = {
    cgw-name = "sof-onpremise"
    env      = "sof-aws-prod"
    bgp-asn  = 65000
    ip       = "177.15.130.226"
  }
}

variable vpc-vpn-sof {
  type = list(object(
    {
      vpc-name             = string
      vpc-cidr             = string
      vpc-azs              = list(string)
      private-subnets      = list(string)
      private-subnet-names = list(string)
      public-subnets       = list(string)
      public-subnet-names  = list(string)
      igw-name             = string
      vpg-name             = string

      vpn-name   = string
      vpn-routes = list(string)

      env = string
    }
  ))

  default = [
    {
      vpc-name             = "VPC_SOF"
      vpc-cidr             = "10.100.0.0/16"
      vpc-azs              = ["sa-east-1a"]
      private-subnets      = ["10.100.64.0/20", "10.100.16.0/20", "10.100.0.0/20", "10.100.32.0/20", "10.100.48.0/20"]
      private-subnet-names = ["AWS_SERVICO", "AWS_DOM_RECURSO", "AWS_DMZ", "AWS_GERENCIA", "AWS_KUBERNETES"]
      public-subnets       = ["10.100.254.0/24"]
      public-subnet-names  = ["AWS_PUBLIC"]
      igw-name             = "AWS_INTGW01"
      vpg-name             = "sof-vpg"


      vpn-name   = "VPN_AWS_SOF"
      vpn-routes = ["10.209.68.0/24", "172.27.1.0/24", "172.27.3.0/24", "192.168.20.0/24", "192.168.22.0/24", "192.168.250.0/23"]

      env = "sof-aws-prod"
    }    
  ]
}

variable natgw-instance-sof {
  type = list(object(
    {
      instance-name       = string
      ami                 = string
      type                = string
      access-key-name     = string
      vpc-security-groups = list(string)
      env                 = string
    }
  ))

  default = [
    {
      instance-name       = "aws_natgw01"
      ami                 = "ami-047992932eb72e310"
      type                = "t3.small"
      access-key-name     = "user_svc_aws_inicial"
      vpc-security-groups = ["sg-04b9eb53336ae176b"]
      env                 = "sof-aws-prod"
    }    
  ]
}


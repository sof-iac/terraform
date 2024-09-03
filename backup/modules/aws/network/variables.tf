variable cgw {
  type = object(
    {
      cgw-name = string
      env      = string
      bgp-asn  = number
      ip       = string
    }
  )
}

variable vpc-vpn {
  type = object(
    {
      vpc-name             = string
      vpc-cidr             = string
      vpc-azs              = list(string)
      private-subnets-cidr = list(string)
      private-subnet-names = list(string)
      public-subnets-cidr  = list(string)
      public-subnet-names  = list(string)
      igw-name             = string
      vpg-name             = string

      vpn-name   = string
      vpn-routes = list(string)

      env = string
    }
  )
}

variable natgw-instance {
  type = object(
    {
      instance-name       = string
      ami                 = string
      type                = string
      access-key-name     = string
      vpc-security-groups = list(string)
      env                 = string
    }
  )
}


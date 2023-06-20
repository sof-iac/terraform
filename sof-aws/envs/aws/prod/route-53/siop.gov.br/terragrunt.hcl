include {
  path = find_in_parent_folders()
}

dependency "network" {
  config_path = "../../network"
}

terraform {
  source = "../../../../../modules/aws/route-53"
} 
inputs = {
  zone = {
    name    = "siop.gov.br"
    private = false
    vpc     = {
      vpc_id = null
    } # No caso de uma zona pública (private = false), não é necessário setar a variável vpc
    env     = "sof-aws-prod"
  }

  records = [{
    name    = "www.siop.gov.br"
    type    = "A"
    ttl     = 300
    records = ["177.15.128.40"]
  },
  {
    name    = "webservice.siop.gov.br"
    type    = "A"
    ttl     = 300
    records = ["177.15.128.41"]
  }]
} 
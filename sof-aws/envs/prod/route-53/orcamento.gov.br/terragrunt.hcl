include {
  path = find_in_parent_folders()
}

dependency "network" {
  config_path = "../../network"
}

terraform {
  source = "../../../../modules/route-53"
} 
inputs = {
  zone = {
    name    = "orcamento.gov.br"
    private = false
    vpc     = {
      vpc_id = null
    } # No caso de uma zona pública (private = false), não é necessário setar a variável vpc
    env     = "sof-aws-prod"
  }

  records = [{
    name    = "www.orcamento.gov.br"
    type    = "A"
    ttl     = 300
    records = ["177.15.128.42"]
  },
  {
    name    = "www2.orcamento.gov.br"
    type    = "A"
    ttl     = 300
    records = ["177.15.128.44"]
  }]
} 
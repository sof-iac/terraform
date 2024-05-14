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
    name    = "orcamento.gov.br"
    private = false
    vpc     = {
      vpc_id = null
    } # No caso de uma zona pública (private = false), não é necessário setar a variável vpc
    env     = "sof-aws-prod"
  }

  records = [{
    name    = "www"
    type    = "A"
    ttl     = 300
    records = ["189.9.7.53"]
  },
  {
    name    = "www2"
    type    = "A"
    ttl     = 300
    records = ["177.15.128.44"]
  }]
} 
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
    name    = "sof.gov.br"
    private = false
    vpc     = {
      vpc_id = null
    } # No caso de uma zona pública (private = false), não é necessário setar a variável vpc
    env     = "sof-aws-prod"
  }

  records = null
} 
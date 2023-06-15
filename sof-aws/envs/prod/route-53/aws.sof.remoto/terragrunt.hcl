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
    name    = "aws.sof.remoto"
    private = true
    vpc     = {
      vpc_id = dependency.network.outputs.vpc_id
    } # No caso de uma zona pública (private = false), não é necessário setar a variável vpc
    env     = "sof-aws-prod"
  }

  records = [{
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
  }]
}
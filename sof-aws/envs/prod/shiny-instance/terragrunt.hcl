include {
  path = find_in_parent_folders()
}

dependency "network" {
  config_path = "../network"
}

terraform {
  source = "../../../modules/ec2-instance"
}

inputs = {
  ec2-instance = [{
    name                   = "AWS-PSHI01"
    ami                    = "ami-0b7af114fb404cd23"
    type                   = "t3.small"
    access-key-name        = "user_svc_aws_shiny_server"
    vpc-security-group-ids = ["sg-0255ccf763093020b"]
    subnet-id              = dependency.network.outputs.subnet-servico
    env                    = "sof-aws-prod"
}
]}


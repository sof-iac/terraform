locals {
  env    = "prod" #local.parsed.env
  secrets         = jsondecode(file("secrets.json"))  
  username_vcenter = local.secrets.username_vcenter  
  passwd_vcenter   = local.secrets.passwd_vcenter 
}
inputs = {
  minio_pem = file("minio.pem")
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "vsphere" {
  user           = "${local.username_vcenter}"
  password       = "${local.passwd_vcenter}"
  vsphere_server = "pvcn01.sof.intra"

  # if you have a self-signed cert
  allow_unverified_ssl = true
}
EOF
}
remote_state {
  backend = "local"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite"
  }
  config = {
    path = "/data/terraform.tfstate"
  }
}



 
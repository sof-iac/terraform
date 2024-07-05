# Le o arquivo gerado no step anterior que busca a secret do vault
inputs = {
  user_svc_passwd = file("secrets.txt")
}
# gera o arquivo provider.tf com a conexao com o vcenter
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "vsphere" {
  user           = "user_svc_vcenter"
  password       =  var.user_svc_passwd
  vsphere_server = "pvcn01.sof.intra"

  # if you have a self-signed cert
  allow_unverified_ssl = true
}
EOF
}

# Armazena o estado
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


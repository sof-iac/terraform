inputs = {
  username_vcenter = "user_svc_vcenter"
  passwd_vcenter = file("secrets.txt")
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "vsphere" {
  user           = var.username_vcenter
  password       =  var.passwd_vcenter
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



 
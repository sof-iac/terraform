inputs = {
  vault_token = "hvs.CAESIEhTzySs_Mc68sZniBZykJsi22HHjAwk2LQeUVDrBhuKGh4KHGh2cy54cHV6ZTcwNjJZV3loQjR0RkxVME8welU"
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "vault" {
  address = "https://vault.app.sof.intra"
  token   = var.vault_token
}

data "vault_generic_secret" "vsphere_credentials" {
  path = "secrets/servicos/user_svc_vcenter"
}

provider "vsphere" {
  user           = "user_svc_vcenter"
  password       = var.user_svc_passwd
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


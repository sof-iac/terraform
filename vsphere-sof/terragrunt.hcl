inputs = {
  vault_token = "hvs.CAESIJ9vAM7KXI0Y8T0GFmiQfd4ucGHVlx3QSG8MFHdFISqkGh4KHGh2cy5jcnJ1R0U1Z0lOU2g0aTg5cm9lR0g4UzU"
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
  path = "servicos/jenkins/user_svc_vcenter"
}

provider "vsphere" {
  user           = "user_svc_vcenter"
  password       = data.vault_generic_secret.vsphere_credentials.data["user_svc_vcenter_passwd"]
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
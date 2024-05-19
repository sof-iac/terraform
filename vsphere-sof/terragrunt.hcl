variable "vault_token" {
  description = "Token do Vault"
}

provider "vault" {
  address = "https://vault.app.sof.intra"
  token   = var.vault_token
}

data "vault_generic_secret" "vsphere_credentials" {
  path = "servicos/jenkins/user_svc_vcenter"
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
variable "vsphere_user" {
  description = "Usuário do vCenter"
  default     = "${data.vault_generic_secret.vsphere_credentials.data["user_svc_vcenter"]}"
}

variable "vsphere_password" {
  description = "Senha do vCenter"
  sensitive   = true
  default     = "${data.vault_generic_secret.vsphere_credentials.data["user_svc_vcenter_passwd"]}"
}

provider "vsphere" {
  user           = var.vsphere_user
  password       = var.vsphere_password
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
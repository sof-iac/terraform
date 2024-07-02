inputs = {
  vault_token = "hvb.AAAAAQK70zSdRXB2BlwIMJf7GoOUI4ULy-Cl7lRkVKptIrJ31bVshSqwoWNKErEicH7qs6P9Ox2ncKffN3pX-7k44RwJeE1HnFR8OlmkKpxiZ0Lhcmt3fRGlcFMVoXKgaDrNVldnvY6_Q42-JRi6-bjwb-RLeoVutTdF0KZqMLzLZ7s_AcNTxDixuTwO7Qc8d_hFXM6JSo5pcoLWANxfsBBvKlfDp1kp4BC676ynbjae"
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
  password       = data.vault_generic_secret.vsphere_credentials.data["username"]
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


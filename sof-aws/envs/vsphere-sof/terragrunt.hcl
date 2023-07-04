generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "vsphere" {
  user           = ""
  password       = ""
  vsphere_server = "pvcn01.sof.intra"

  # if you have a self-signed cert
  allow_unverified_ssl = true
}
EOF
}
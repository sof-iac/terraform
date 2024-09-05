# terragrunt.hcl
terraform {
  source = "vault_cert.tf"
}

include {
  path = find_in_parent_folders()
}

# terragrunt.hcl
terraform {
  source = "main.tf"
}

include {
  path = find_in_parent_folders()
}

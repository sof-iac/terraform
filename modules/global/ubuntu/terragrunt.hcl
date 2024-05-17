# terragrunt.hcl
terraform {
  source = "bluprint.tf"
}

include {
  path = find_in_parent_folders()
}

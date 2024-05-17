# terragrunt.hcl
terraform {
  source = "blueprint.tf"
}

include {
  path = find_in_parent_folders()
}

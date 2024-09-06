include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../../../modules/vsphere/tags_vcenter"  # Caminho relativo ao terragrunt.hcl
}

inputs = {
  tag = {
    "Tags_Terraform" = {
      category_name        = "Terraform_VM_BD"
      category_description = "Vms de bancos de dados - Terraform"
      tag_name             = "Terraform_BD_Mariadb"
      tag_description      = "Vms de banco Mariadb - Terraform"

      } 
    }   
}


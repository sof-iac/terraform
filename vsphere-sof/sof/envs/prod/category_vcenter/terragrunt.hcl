include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../../../modules/vsphere/category_vcenter"  # Caminho relativo ao terragrunt.hcl
}

inputs = {
  category = {
    "category_ambiente" = {
      category_name        = "Ambiente"
      category_description = "Ambiente que contem o recurso"
      }             
    }   
}


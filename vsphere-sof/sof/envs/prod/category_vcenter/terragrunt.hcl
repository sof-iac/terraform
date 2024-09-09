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
      },
    "category_Origem" = {
      category_name        = "Origem"
      category_description = "Via codigo ou Manual"
      }, 
    "category_guest_os" = {
      category_name        = "Guest_OS"
      category_description = "Qual o sisteam operacional"
      }                       
    }   
}


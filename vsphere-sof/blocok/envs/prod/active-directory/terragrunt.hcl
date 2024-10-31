include {
  path = find_in_parent_folders()
}

terraform {
  #source = "../../../../../modules/vsphere/linux_vm"
  source = "../../../../../modules/active-directory"  # Caminho relativo ao terragrunt.hcl
}

inputs = {
  org-unit = {
    "Contas_Admin" = { 
       path        = "DC=blocok,DC=sof,DC=remoto"
       description = ""
       protected   = false
    }
  }
}
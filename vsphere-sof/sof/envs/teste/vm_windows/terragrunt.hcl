include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../../../modules/vsphere/vm/windows"  # Caminho relativo ao terragrunt.hcl
}

inputs = {
  vm = {
    "PPPP01" = {
      datacenter        = "SOF" 
      datastore_cluster = "Storage_Purestorage"
      datastore         = "Storage_Purestorage"
      resource_pool     = "Blade_Kratos/Resources"
      vsphere_cluster   = "Blade_Kratos"
      vmname            = {"hostname" = ["PPPP01"]}
      template          = "templateserver2022datacenter"
      instances         = 1
      cpu               = 4
      memory            = 4096
      local_adminpass   = "sof123"

      network           = {"PG_Atlas_Teste" = ["192.168.30.50", "10.13.113.3"]}
      mask              = ["24"]
      gateway           = "192.168.250.1"
      annotation        = "Servidor de teste windows- 11/09/2024 - Rogerio Vieira Silva"
      tags = {
        "Origem"    = "Terraform"
      }
      # Adicionando discos adicionais  
      data_disk = {  
        "disk_A1" = {  
          size_gb                = 30  
          unit_number            = 3  
          thin_provisioned       = true  
          eagerly_scrub          = false  
          #datastore_id           = "Storage_Purestorage"  
          storage_policy_id      = null  
          io_reservation         = null  
          io_share_level         = "normal"  
          disk_mode              = null  
          disk_sharing           = null  
          attach                 = null  
          path                   = null 
        }  
      }
      } 
    }   
}


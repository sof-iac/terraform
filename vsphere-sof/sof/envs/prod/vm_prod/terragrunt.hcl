include {
  path = find_in_parent_folders()
}

terraform {
  #source = "../../../../../modules/vsphere/linux_vm"
  source = "../../../../../modules/vsphere/vm/linux"  # Caminho relativo ao terragrunt.hcl
}

inputs = {
  vm = {
    "PSBD28" = {
        template          = "templateubuntu2204_ansible"
        instances         = 1
        datacenter        = "SOF" #dependency.dc-config.outputs.dc_id
        datastore_cluster = "Storage_Purestorage"
        datastore         = "Storage_Purestorage"
        resource_pool     = "Blade_Kratos/Resources"
        vsphere_cluster   = "Blade_Kratos"
        network           = {"PG_Atlas_Gerencia" = ["192.168.250.159"]}
        mask              = ["24"]
        gateway           = "192.168.250.1"
        cpu               = 8
        memory            = 8192
        # Adicionando discos adicionais  
        data_disk = {  
          "disk_A1" = {  
            size_gb                = 250  
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


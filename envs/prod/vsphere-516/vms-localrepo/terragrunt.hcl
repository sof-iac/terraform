include {
  path = find_in_parent_folders()
}

terraform {
  #source = "../../../../../modules/vsphere/linux_vm"
  source = "../../../../modules/vsphere/vm/linux"  # Caminho relativo ao terragrunt.hcl
}

locals {  
  TF_VAR_VM_PASS = get_env("TF_VAR_VM_PASS")
  TF_VAR_DISTRO  = get_env("TF_VAR_DISTRO")
}  

inputs = {
  vm = {    
    "PREP" = {
        template          = "templateubuntu2204_ansible"
        instances         = 1
        vmstartcount      = 3        
        datacenter        = "SOF" #dependency.dc-config.outputs.dc_id
        datastore_cluster = "Storage_Purestorage"
        datastore         = "Storage_Purestorage"
        resource_pool     = "Blade_Atreus/Resources"
        vsphere_cluster   = "Blade_Atreus"
        network           = {"PG_Atlas_Dominio_Recurso" = ["172.27.3.125"]}
        mask              = ["24"]
        gateway           = "172.27.3.1"
        domain            = "sof.intra"
        cpu               = 2
        memory            = 8192
        local_adminpass   = "${local.TF_VAR_VM_PASS}"
        distro            = "${local.TF_VAR_DISTRO}"        
        network_type      = ["vmxnet3"]
        annotation        = "Repositorio do Ubuntu - 19/06/2024 - Rogerio Vieira Silva"
        tags = {
          "Origem"    = "Terraform"
          "Ambiente"  = "Prod"
          "Aplicacao" = "repositorio"
          "Responsavel" = "Rogerio_Vieira_Silva"
        }
        # Adicionando discos adicionais  
        data_disk = {  
          "disk_A1" = {  
            size_gb                = 500  
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


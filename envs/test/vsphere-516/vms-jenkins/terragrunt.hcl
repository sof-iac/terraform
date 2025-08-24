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
    "PJEN" = {
        template          = "default-template-ubuntu2404-base"
        instances         = 1
        vmstartcount      = 4       
        datacenter        = "SOF" #dependency.dc-config.outputs.dc_id
        datastore_cluster = "Purestorage_Default"
        datastore         = "Purestorage_Default"
        resource_pool     = "Blade_Kratos/Resources"
        vsphere_cluster   = "Blade_Kratos"
        network           = {"PG_Gaia_Dominio_Recurso" = ["172.27.3.126"]}
        mask              = ["24"]
        gateway           = "172.27.3.1"
        cpu               = 2
        memory            = 8192
        domain            = "sof.intra"
        local_adminpass   = "${local.TF_VAR_VM_PASS}"
        distro            = "${local.TF_VAR_DISTRO}"        
        network_type      = ["vmxnet3"]
        annotation        = "Servidor que subsituira o PJEN02 - 24/08/2025 - Rogerio Vieira Silva"
        tags = {
          "Origem"    = "Terraform"
          "Ambiente"  = "Prod"
          "Aplicacao" = "Jenkins"
          "Responsavel" = "Rogerio Vieira Silva"
        }
        # Adicionando discos adicionais  
        data_disk = {  
          "disk_A1" = {  
            size_gb                = 80  
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


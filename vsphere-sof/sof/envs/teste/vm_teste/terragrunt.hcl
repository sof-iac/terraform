# Definindo locais se necessário  
locals {  
  vm_user          = "root"         # Ou uma string real ou faça referência direta  
}

include {
  path = find_in_parent_folders()
}

terraform {
  #source = "../../../../../modules/vsphere/linux_vm"
  source = "../../../../../modules/vsphere/vm/linux"  # Caminho relativo ao terragrunt.hcl
}

inputs = {
  vm = {
    "testetf" = {
        template          = "templateubuntu2204_ansible"
        instances         = 1
        datacenter        = "SOF" #dependency.dc-config.outputs.dc_id
        datastore_cluster = "Storage_Purestorage"
        datastore         = "Storage_Purestorage"
        resource_pool     = "Blade_Atreus/Resources"
        vsphere_cluster   = "Blade_Atreus"
        network           = {"PG_Atlas_Teste" = ["192.168.30.172"]}
        mask              = ["24"]
        gateway           = "192.168.30.1"
        cpu               = 2
        memory            = 8192
        vm_user           = local.vm_user  # Passando a variável
        vm_pass           = "${vm_pass}"
        # Adicionando discos adicionais  
        data_disk = {  
          "disk_A1" = {  
            size_gb                = 6  
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
          },  
          "disk_A2" = {  
            size_gb                = 8  
            unit_number            = 4  
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
    },  
    "orcl01" = {
        template          = "templateoraclelinux810"
        instances         = 1
        datacenter        = "SOF" #dependency.dc-config.outputs.dc_id
        datastore_cluster = "Storage_Purestorage"
        datastore         = "Storage_Purestorage"
        resource_pool     = "Blade_Atreus/Resources"
        vsphere_cluster   = "Blade_Atreus"
        network           = {"PG_Atlas_Teste" = ["192.168.30.173"]}
        mask              = ["24"]
        gateway           = "192.168.30.1"
        cpu               = 2
        memory            = 8192
        vm_user           = local.vm_user  # Passando a variável
        vm_pass           = "${vm_pass}"
        data_disk         = {}
    }
  }     
}


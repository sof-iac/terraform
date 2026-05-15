terraform {
  source = "../../../../modules/vsphere/vm/linux"  # Caminho relativo ao terragrunt.hcl
}

include {
  path = find_in_parent_folders()
}

locals {  
  vcenter        = basename(dirname(get_terragrunt_dir()))
  TF_VAR_VM_PASS = get_env("TF_VAR_VM_PASS")
  TF_VAR_DISTRO  = get_env("TF_VAR_DISTRO")
} 
  

inputs = {
  vm = {
    "TELK" = {
        template          = "default-template-ubuntu2404-base"
        instances         = 3
        vmstartcount      = 4
        datacenter        = "SOF" #dependency.dc-config.outputs.dc_id
        datastore_cluster = "Purestorage_Default"
        resource_pool     = "Blade_Kratos/Resources"
        vsphere_cluster   = "Blade_Kratos"
        domain            = "sof.intra"
        network           = {"PG_Gaia_Teste" = ["192.168.30.234","192.168.30.235","192.168.30.236"]}
        dns_server_list   = ["172.27.3.5", "172.27.3.6"]
        mask              = ["24"]
        gateway           = "192.168.30.1"
        cpu               = 4
        memory            = 8192
        local_adminpass   = "${local.TF_VAR_VM_PASS}"
        distro            = "${local.TF_VAR_DISTRO}"
        network_type      = ["vmxnet3"]
        annotation        = "Servidor do cluster ELK de serviços da rede de Testes | João Francisco, COINF | 2026-05-15"
        tags = {
          "Origem"    = "Terraform"
          "Ambiente"  = "Test"
          "Aplicacao" = "ELK"
          "Responsavel" = "Joao Francisco"
        }        
        # Discos adicionais 
        template_disk_io_reservation = [1,1,1]  
        data_disk = {  
          "disk_A1" = {  
            size_gb                = 100
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


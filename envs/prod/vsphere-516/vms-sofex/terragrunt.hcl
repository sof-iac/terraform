include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../../modules/vsphere/vm/linux"  # Caminho relativo ao terragrunt.hcl
}

locals {
  TF_VAR_VM_PASS = get_env("TF_VAR_VM_PASS")
  TF_VAR_DISTRO  = get_env("TF_VAR_DISTRO")
}

inputs = {
  vm = {
    # Definição VM para o banco de dados do extrator de eventos das maquinas Windows
    "PSBD" = {
      template          = "default-template-alma-9.6-base"
      staticvmname      = "PSBD77"
      instances         = 1
      vmstartcount      = 1
      datacenter        = "SOF"
      datastore_cluster = "Purestorage_Default"
      datastore         = "Purestorage_Default"
      resource_pool     = "Blade_Kratos/Resources"
      vsphere_cluster   = "Blade_Kratos"
      domain            = "sof.intra"
      network           = {"PG_Gaia_Apl_Internas" = ["192.168.50.177"]}
      dns_server_list   = ["172.27.3.5", "172.27.3.6"]
      mask              = ["24"]
      gateway           = "192.168.50.1"
      cpu               = 16
      memory            = 65536
      local_adminpass   = "${local.TF_VAR_VM_PASS}"
      distro            = "${local.TF_VAR_DISTRO}"
      network_type      = ["vmxnet3"]
      annotation        = "Servidor de Banco de Dados da Aplicação do Extrator de Eventos | João Francisco, COINF | 2026-01-14"
      tags = {
        "Origem"      = "Terraform"
        "Ambiente"    = "Prod"
        "Aplicacao"   = "Sofex"
        "Responsavel" = "Joao_Francisco"
      }
      # Adicionando discos adicionais
      data_disk = { 
          "disk_A1" = {  
            size_gb                = 1024
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

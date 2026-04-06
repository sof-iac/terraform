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
    "TGIT" = {
      template          = "default-template-ubuntu2404-base"
      staticvmname      = "TGIT01"
      instances         = 1
      vmstartcount      = 1
      datacenter        = "SOF"
      datastore_cluster = "Purestorage_Default"
      resource_pool     = "Blade_Kratos/Resources"
      vsphere_cluster   = "Blade_Kratos"
      domain            = "sof.intra"
      network           = {"PG_Gaia_Teste" = ["192.168.30.85"]}
      dns_server_list   = []
      mask              = ["24"]
      gateway           = "192.168.30.1"
      cpu               = 4
      memory            = 16384
      local_adminpass   = "${local.TF_VAR_VM_PASS}"
      distro            = "${local.TF_VAR_DISTRO}"
      network_type      = ["vmxnet3"]
      annotation        = "Servidor Gitlab"
      tags = {
        "Origem"    = "Terraform"
        "Ambiente"  = "dev"
        "Aplicacao" = "Gitlab"
      }
      # Adicionando discos adicionais
      template_disk_sizes = [21, 51, 20] 
      template_disk_io_reservation = [0, 0, 1]
      data_disk = {
        "disk_A1" = {
          size_gb                = 20
          unit_number            = 3
          thin_provisioned       = true
          eagerly_scrub          = false
          #datastore_id           = "Storage_Purestorage"
          storage_policy_id      = null
          io_reservation         = 1
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

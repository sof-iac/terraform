terraform {
  source = "../../../../modules/vsphere/vm/linux"  # Caminho relativo ao terragrunt.hcl
}

include {
  path = find_in_parent_folders()
}

locals {
  vcenter        = basename(dirname(get_terragrunt_dir()))
  TF_VAR_VM_PASS = get_env("TF_VAR_VM_PASS")
}

inputs = {
  vm = {
    "TSBD" = {
        template          = "default-template-ubuntu2404-base"
        instances         = 1
        vmstartcount      = 31
        staticvmname      = null
        datacenter        = "SOF" #dependency.dc-config.outputs.dc_id
        datastore_cluster = "Purestorage_Default"
        resource_pool     = "Blade_Kratos/Resources"
        vsphere_cluster   = "Blade_Kratos"
        domain            = "sof.intra"
        network           = {"PG_Gaia_Teste" = ["192.168.30.97"]}
        dns_server_list   = ["172.27.3.5", "172.27.3.6"]
        mask              = ["24"]
        gateway           = "192.168.30.1"
        cpu               = 6
        memory            = 8192
        local_adminpass   = "${local.TF_VAR_VM_PASS}"
        network_type      = ["vmxnet3"]
        annotation        = "Vm teste Banco de Dados 17/07/2026 - Chamado 7477 Mauricio Almeida"
        tags = {
          "Origem"    = "Terraform"
          "Ambiente"  = "Test"
          "Aplicacao" = "Postgresql"
        }

        # Adicionando discos adicionais
      template_disk_sizes = [21, 51, 17] 
      template_disk_io_reservation = [0, 0, 1]
      data_disk = {
        "disk_A1" = {
          size_gb                = 80
          unit_number            = 3
          thin_provisioned       = true
          eagerly_scrub          = false
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
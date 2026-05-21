terraform {
  source = "../../../../modules/vsphere/vm/linux"
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

    "PSAP01K-WILDFLY" = {
      template          = "default-template-alma-9.6-base"
      instances         = 1
      vmstartcount      = 1
      staticvmname      = "PSAP01K-WILDFLY"
      datacenter        = "BLOCOK"
      datastore_cluster = "Purestorage_K"
      resource_pool     = "Blade_DTI/Resources"
      vsphere_cluster   = "Blade_DTI"
      domain            = "blk.sof.intra"
      network           = { "PG_Gaia_DMZ_Servico_Producao" = ["192.168.121.12"] }
      dns_server_list   = []
      mask              = ["24"]
      gateway           = "192.168.121.1"
      cpu               = 4
      memory            = 13312
      local_adminpass   = "${local.TF_VAR_VM_PASS}"
      distro            = "${local.TF_VAR_DISTRO}"
      network_type      = ["vmxnet3"]
      annotation        = "Servidor de Producao Wildfly - 21/05/2026 - Rogerio Vieira"
      tags = {
        "Origem"       = "Terraform"
        "Ambiente"     = "Prod"
        "Aplicacao"    = "Wildfly"
        "Responsavel"  = "Rogerio Vieira Silva"
      }
      template_disk_io_reservation = [1, 1, 1]
      data_disk                    = {}
    }

    "PSAP04K-WILDFLY" = {
      template          = "default-template-alma-9.6-base"
      instances         = 1
      vmstartcount      = 4
      staticvmname      = "PSAP04K-WILDFLY"
      datacenter        = "BLOCOK"
      datastore_cluster = "Purestorage_K"
      resource_pool     = "Blade_DTI/Resources"
      vsphere_cluster   = "Blade_DTI"
      domain            = "blk.sof.intra"
      network           = { "PG_Gaia_DMZ_Servico_Producao" = ["192.168.121.13"] }
      dns_server_list   = []
      mask              = ["24"]
      gateway           = "192.168.121.1"
      cpu               = 4
      memory            = 13312
      local_adminpass   = "${local.TF_VAR_VM_PASS}"
      distro            = "${local.TF_VAR_DISTRO}"
      network_type      = ["vmxnet3"]
      annotation        = "Servidor de Producao Wildfly - 14/05/2026 - Rogerio Vieira"
      tags = {
        "Origem"       = "Terraform"
        "Ambiente"     = "Prod"
        "Aplicacao"    = "Wildfly"
        "Responsavel"  = "Rogerio Vieira Silva"
      }
      template_disk_io_reservation = [1, 1, 1]
      data_disk                    = {}
    }    

  }
}

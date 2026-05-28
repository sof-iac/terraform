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

  # 1. Definição do mapeamento exclusivo de cada VM: [IP, vmstartcount]
  vm_matrix = {
    "PSAP01" = ["192.168.20.11", 1]
    "PSAP02" = ["192.168.20.21", 2]
    "PSAP03" = ["192.168.20.22", 3]
    "PSAP04" = ["192.168.20.25", 4]
    "PSAP10" = ["192.168.20.17", 10]
  }
}

inputs = {
  vm = {
    for name, config in local.vm_matrix : name => {
      staticvmname      = name
      network           = { "PG_Gaia_DMZ_Servico_Producao" = [config[0]] }
      vmstartcount      = config[1]
      
      # Valores padrão replicados automaticamente para todas as instâncias
      template          = "default-template-alma-9.6-base"
      instances         = 1
      datacenter        = "SOF"
      datastore_cluster = "Purestorage_Default"
      resource_pool     = "Blade_Kratos/Resources"
      vsphere_cluster   = "Blade_Kratos"
      domain            = "sof.intra"
      dns_server_list   = []
      mask              = ["24"]
      gateway           = "192.168.20.1"
      cpu               = 4
      memory            = 13312
      local_adminpass   = local.TF_VAR_VM_PASS
      distro            = local.TF_VAR_DISTRO
      network_type      = ["vmxnet3"]
      annotation        = "Servidor de Producao Wildfly - 14/05/2026 - Rogerio Vieira"
      
      tags = {
        "Origem"      = "Terraform"
        "Ambiente"    = "Prod"
        "Aplicacao"   = "Wildfly"
        "Responsavel" = "Rogerio Vieira Silva"
      }
      
      template_disk_io_reservation = [1, 1, 1]
      data_disk                    = {}
    }
  }
}
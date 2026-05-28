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

  # Matriz mapeada com os novos IPs sequenciais disponíveis
  vm_matrix = {
    "DSAP01"          = ["192.168.30.17", 1]
    "DSAP02"          = ["192.168.30.27", 2]
    "DSAP03"          = ["192.168.30.28", 3]
    "DSAP04"          = ["192.168.30.29", 4]
    "DSAP05"          = ["192.168.30.30", 5]
    "DSAP06-WILDFLY"  = ["192.168.30.32", 6]
    "DSAP07"          = ["192.168.30.33", 7]
    "DSAP08"          = ["192.168.30.35", 8]
    "DSAP09"          = ["192.168.30.36", 9]
    "DSAP10"          = ["192.168.30.37", 10]
    "DSAP20"          = ["192.168.30.39", 20]
  }
}

inputs = {
  vm = {
    for name, config in local.vm_matrix : name => {
      staticvmname      = name
      network           = { "PG_Gaia_Teste" = [config[0]] }
      vmstartcount      = config[1]
      
      # Valores padrão reaproveitados para todas as instâncias
      template          = "default-template-alma-9.6-base"
      instances         = 1
      datacenter        = "SOF"
      datastore_cluster = "Purestorage_Default"
      resource_pool     = "Blade_Kratos/Resources"
      vsphere_cluster   = "Blade_Kratos"
      domain            = "sof.intra"
      dns_server_list   = []
      mask              = ["24"]
      gateway           = "192.168.30.1"
      cpu               = 2
      memory            = 2048
      local_adminpass   = local.TF_VAR_VM_PASS
      distro            = local.TF_VAR_DISTRO
      network_type      = ["vmxnet3"]
      annotation        = "Servidor de Testes 28/05/2026"
      
      tags = {
        "Origem"      = "Terraform"
        "Ambiente"    = "Test"
        "Aplicacao"   = "Wildfly"
      }
      
      template_disk_io_reservation = [1, 1, 1]
      data_disk                    = {}
    }
  }
}
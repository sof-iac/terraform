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
    "TSAP01"          = ["192.168.30.131", 1]
    "TSAP02"          = ["192.168.30.202", 2]
    "TSAP03"          = ["192.168.30.203", 3]
    "TSAP04"          = ["192.168.30.204", 4]
    "TSAP05"          = ["192.168.30.205", 5]
    "TSAP06-WILDFLY"  = ["192.168.30.145", 6]
    "TSAP07"          = ["192.168.30.208", 7]
    "TSAP08"          = ["192.168.30.180", 8]
    "TSAP09"          = ["192.168.30.182", 9]
    "TSAP10"          = ["192.168.30.184", 10]
    "TSAP20"          = ["192.168.30.186", 20]
  }
}

inputs = {
  # 2. Construção dinâmica do mapa de VMs injetando os valores padrão
  vm = {
    for name, config in local.vm_matrix : name => {
      staticvmname      = name
      network           = { "PG_Gaia_Teste" = [config[0]] }
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
      gateway           = "192.168.30.1"
      # Condicionais para aplicar CPU e memória customizadas
      cpu               = name == "TSAP07" ? 8 : 4
      memory            = name == "TSAP07" ? 24576 : 13312
      local_adminpass   = local.TF_VAR_VM_PASS
      distro            = local.TF_VAR_DISTRO
      network_type      = ["vmxnet3"]
      annotation        = "Servidor de Testes Wildfly - 18/04/2026 - Rogerio Vieira"
      
      tags = {
        "Origem"      = "Terraform"
        "Ambiente"    = "Test"
        "Aplicacao"   = "Wildfly"
        "Responsavel" = "Rogerio Vieira Silva"
      }
      
      template_disk_io_reservation = [1, 1, 1]
      data_disk                    = {}
    }
  }
}
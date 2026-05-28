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
    "HSAP01-WILDFLY"          = ["192.168.40.20", 1]
  }
}

inputs = {
  # 2. Construção dinâmica do mapa de VMs injetando os valores padrão
  vm = {
    for name, config in local.vm_matrix : name => {
      staticvmname      = name
      network           = { "PG_Gaia_DMZ_Servico_Homolocacao" = [config[0]] }
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
      gateway           = "192.168.40.1"
      cpu               = 4
      memory            = 13312
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
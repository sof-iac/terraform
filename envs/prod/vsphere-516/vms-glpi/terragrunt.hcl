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
    # Definição VM para o servidor GLPI de produção
    "PGLP" = {
      template          = "default-template-ubuntu2404-base"
      instances         = 1
      vmstartcount      = 2
      datacenter        = "SOF"
      datastore_cluster = "Purestorage_Replicado"
      resource_pool     = "Blade_Kratos/Resources"
      vsphere_cluster   = "Blade_Kratos"
      domain            = "sof.intra"
      network           = {"PG_Gaia_Apl_Internas" = ["192.168.50.65"]}
      dns_server_list   = ["172.27.3.5", "172.27.3.6"]
      mask              = ["24"]
      gateway           = "192.168.50.1"
      cpu               = 4
      memory            = 16384
      local_adminpass   = "${local.TF_VAR_VM_PASS}"
      distro            = "${local.TF_VAR_DISTRO}"
      network_type      = ["vmxnet3"]
      annotation        = "Servidor GLPI - Solicitacao 7376 (Thiago Neves)"
      tags = {
        "Origem"    = "Terraform"
        "Ambiente"  = "Prod"
        "Aplicacao" = "GLPI"
        "Responsavel" = "Alexander Moreira de Morais"
      }
      template_disk_sizes = [21, 101, 20]
      template_disk_io_reservation = [0,1,0]
      # Adicionando discos adicionais
      data_disk = {}
    },
     "PSBD" = {
      template          = "default-template-ubuntu2404-base"
      instances         = 1
      vmstartcount      = 14
      datacenter        = "SOF"
      datastore_cluster = "Purestorage_Replicado"
      resource_pool     = "Blade_Kratos/Resources"
      vsphere_cluster   = "Blade_Kratos"
      domain            = "sof.intra"
      network           = {"PG_Gaia_Apl_Internas" = ["192.168.50.66"]}
      dns_server_list   = ["172.27.3.5", "172.27.3.6"]
      mask              = ["24"]
      gateway           = "192.168.50.1"
      cpu               = 4
      memory            = 16384
      local_adminpass   = "${local.TF_VAR_VM_PASS}"
      distro            = "${local.TF_VAR_DISTRO}"
      network_type      = ["vmxnet3"]
      annotation        = "Servidor de Banco GLPI (MariaDB) - Solicitacao 7376 (Thiago Neves)"
      tags = {
        "Origem"    = "Terraform"
        "Ambiente"  = "Prod"
        "Aplicacao" = "MariaDB"
        "Responsavel" = "Alexander Moreira de Morais"
      }
      template_disk_sizes = [21, 101, 20]
      template_disk_io_reservation = [0,1,0]
      # Adicionando discos adicionais
      data_disk = {}
    }   
  }
}

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
    # Definição VM para acesso aos NFS utilizados pelo NetBackup
    "PNBP" = {
      template          = "templateoraclelinux810"
      staticvmname      = "PNBP01"
      instances         = 1
      vmstartcount      = 1
      datacenter        = "SOF"
      datastore_cluster = "Purestorage_Default"
      datastore         = "Purestorage_Default"
      resource_pool     = "Blade_Kratos/Resources"
      vsphere_cluster   = "Blade_Kratos"
      domain            = "sof.intra"
      network           = {"PG_Gaia_Apl_Internas" = ["192.168.50.222"]}
      dns_server_list   = ["172.27.3.5", "172.27.3.6"]
      mask              = ["24"]
      gateway           = "192.168.50.1"
      cpu               = 2
      memory            = 8192
      local_adminpass   = "${local.TF_VAR_VM_PASS}"
      distro            = "${local.TF_VAR_DISTRO}"
      network_type      = ["vmxnet3"]
      annotation        = "Servidor NFS NetBackup | João Francisco, COINF | 2025-12-09"
      tags = {
        "Origem"    = "Terraform"
        "Ambiente"  = "Prod"
        "Aplicacao" = "NetBackup"
      }
      # Adicionando discos adicionais
      data_disk = { }
    }
  }
}

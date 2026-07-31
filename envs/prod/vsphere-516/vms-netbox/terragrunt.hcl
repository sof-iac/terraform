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
    # Definição VM para o servidor Netbox de produção
    "PHIP" = {
      template          = "default-template-ubuntu2404-base"
      instances         = 1
      vmstartcount      = 1
      datacenter        = "SOF"
      datastore_cluster = "Purestorage_Replicado"
      resource_pool     = "Blade_Kratos/Resources"
      vsphere_cluster   = "Blade_Kratos"
      domain            = "sof.intra"
      network           = {"PG_Gaia_Apl_Internas" = ["192.168.50.67"]}
      dns_server_list   = ["172.27.3.5", "172.27.3.6"]
      mask              = ["24"]
      gateway           = "192.168.50.1"
      cpu               = 2
      memory            = 4096
      local_adminpass   = "${local.TF_VAR_VM_PASS}"
      distro            = "${local.TF_VAR_DISTRO}"
      network_type      = ["vmxnet3"]
      annotation        = "Servidor Netbox - Solicitacao 7598 (Thiago Neves)"
      tags = {
        "Origem"    = "Terraform"
        "Ambiente"  = "Prod"
        "Aplicacao" = "Netbox"
        "Responsavel" = "Thiago Fernandes Neves"
      }
      template_disk_sizes = [21, 101, 20]
      template_disk_io_reservation = [0,1,0]
      # Adicionando discos adicionais
      data_disk = {}
    }
     
  }
}

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

    "PSAPK01" = {
      template          = "default-template-alma-9.6-base"
      instances         = 1
      vmstartcount      = 1
      staticvmname      = "PSAPK01"
      datacenter        = "BLOCOK"
      datastore_cluster = "Purestorage_K"
      resource_pool     = "Blade_DTI/Resources"
      vsphere_cluster   = "Blade_DTI"
      domain            = "blk.sof.intra"
      network           = { "PG_Servico" = ["192.168.121.11"] }
      dns_server_list   = ["192.168.80.10"]
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

    "PSAPK04-WILDFLY" = {
      template          = "default-template-alma-9.6-base"
      instances         = 1
      vmstartcount      = 4
      staticvmname      = "PSAPK04-WILDFLY"
      datacenter        = "BLOCOK"
      datastore_cluster = "Purestorage_K"
      resource_pool     = "Blade_DTI/Resources"
      vsphere_cluster   = "Blade_DTI"
      domain            = "blk.sof.intra"
      network           = { "PG_Servico" = ["192.168.121.13"] }
      dns_server_list   = ["192.168.80.10"]
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

  }
}

# PG_Dmz VLAN access: 2443
# Pg_Dominio_Recurso VLAN access: 2442
# PG_Gerencia VLAN access: 2440
# PG_Kubernetes VLAN access: 2444
# PG_Servico VLAN access: 2441
# PG_Dmz para os apaches.
# PG_Dmz - VLAN access: 2443 - rede 172.16.51.0/24
# Pg_Dominio_Recurso - VLAN access: 2442 - rede 192.168.80.0/24
# PG_Gerencia - VLAN access: 2440 - rede 192.168.240.0/24
# PG_Kubernetes - VLAN access: 2444 - rede 192.168.122.0/24
# PG_Servico - VLAN access: 2441 - rede 192.168.121.0/24
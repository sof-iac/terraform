terraform {
  source = "../../../../modules/vsphere/vm/linux"  # Caminho relativo ao terragrunt.hcl
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
    # Data existentes — TELK30, TELK31, TELK32
    "TELK" = {
      template          = "default-template-ubuntu2404-base"
      instances         = 3
      vmstartcount      = 30
      staticvmname      = null
      datacenter        = "SOF" #dependency.dc-config.outputs.dc_id
      datastore_cluster = "Purestorage_Default"
      resource_pool     = "Blade_Kratos/Resources"
      vsphere_cluster   = "Blade_Kratos"
      domain            = "sof.intra"
      network           = { "PG_Gaia_Teste" = ["192.168.30.237", "192.168.30.238", "192.168.30.228"] }
      dns_server_list   = ["172.27.3.5", "172.27.3.6"]
      mask              = ["24"]
      gateway           = "192.168.30.1"
      cpu               = 2
      memory            = 16768
      local_adminpass   = "${local.TF_VAR_VM_PASS}"
      distro            = "${local.TF_VAR_DISTRO}"
      network_type      = ["vmxnet3"]
      annotation        = "Cluste ELK - Augusto Cantanhede - 08/05/2026"
      tags = {
        "Origem"      = "Terraform"
        "Ambiente"    = "Test"
        "Aplicacao"   = "ELK"
        "Responsavel" = "Augusto Cesar Cantanhede"
      }
      template_disk_sizes          = [21, 200, 7]
      template_disk_io_reservation = [0, 1, 0]
      data_disk                    = {}
    },

    # Master-only novas — TELK40, TELK41, TELK42
    # Chave "TELK4" (não "TELK"): "TELK" já é o grupo data; o módulo junta a chave com 0,1,2 → TELK40/41/42
    "TELK4" = {
      template          = "default-template-ubuntu2404-base"
      instances         = 3
      vmstartcount      = 0
      staticvmname      = null
      datacenter        = "SOF"
      datastore_cluster = "Purestorage_Default"
      resource_pool     = "Blade_Kratos/Resources"
      vsphere_cluster   = "Blade_Kratos"
      domain            = "sof.intra"
      network           = { "PG_Gaia_Teste" = ["192.168.30.241", "192.168.30.242", "192.168.30.243"] } # confirmar IPs
      dns_server_list   = ["172.27.3.5", "172.27.3.6"]
      mask              = ["24"]
      gateway           = "192.168.30.1"
      cpu               = 2
      memory            = 8192
      local_adminpass   = "${local.TF_VAR_VM_PASS}"
      distro            = "${local.TF_VAR_DISTRO}"
      network_type      = ["vmxnet3"]
      annotation        = "Cluster ELK - Master-only - Augusto Cantanhede"
      tags = {
        "Origem"      = "Terraform"
        "Ambiente"    = "Test"
        "Aplicacao"   = "ELK"
        "Responsavel" = "Augusto Cesar Cantanhede"
        "Cluster"     = "Master"
      }
      template_disk_sizes          = [21, 40, 7]
      template_disk_io_reservation = [0, 0, 0]
      data_disk                    = {}
    },

    # Kibana — TELK43
    "TELK43" = {
      template          = "default-template-ubuntu2404-base"
      instances         = 1
      vmstartcount      = 43
      staticvmname      = "TELK43"
      datacenter        = "SOF"
      datastore_cluster = "Purestorage_Default"
      resource_pool     = "Blade_Kratos/Resources"
      vsphere_cluster   = "Blade_Kratos"
      domain            = "sof.intra"
      network           = { "PG_Gaia_Teste" = ["192.168.30.244"] } # confirmar IP
      dns_server_list   = ["172.27.3.5", "172.27.3.6"]
      mask              = ["24"]
      gateway           = "192.168.30.1"
      cpu               = 2
      memory            = 8192
      local_adminpass   = "${local.TF_VAR_VM_PASS}"
      distro            = "${local.TF_VAR_DISTRO}"
      network_type      = ["vmxnet3"]
      annotation        = "Cluster ELK - Kibana - Augusto Cantanhede"
      tags = {
        "Origem"      = "Terraform"
        "Ambiente"    = "Test"
        "Aplicacao"   = "ELK"
        "Responsavel" = "Augusto Cesar Cantanhede"
        "Cluster"     = "Kibana"
      }
      template_disk_sizes          = [21, 40, 7]
      template_disk_io_reservation = [0, 0, 0]
      data_disk                    = {}
    },

    # Logstash — TELK44
    "TELK44" = {
      template          = "default-template-ubuntu2404-base"
      instances         = 1
      vmstartcount      = 44
      staticvmname      = "TELK44"
      datacenter        = "SOF"
      datastore_cluster = "Purestorage_Default"
      resource_pool     = "Blade_Kratos/Resources"
      vsphere_cluster   = "Blade_Kratos"
      domain            = "sof.intra"
      network           = { "PG_Gaia_Teste" = ["192.168.30.245"] } # confirmar IP
      dns_server_list   = ["172.27.3.5", "172.27.3.6"]
      mask              = ["24"]
      gateway           = "192.168.30.1"
      cpu               = 4
      memory            = 8192
      local_adminpass   = "${local.TF_VAR_VM_PASS}"
      distro            = "${local.TF_VAR_DISTRO}"
      network_type      = ["vmxnet3"]
      annotation        = "Cluster ELK - Logstash - Augusto Cantanhede"
      tags = {
        "Origem"      = "Terraform"
        "Ambiente"    = "Test"
        "Aplicacao"   = "ELK"
        "Responsavel" = "Augusto Cesar Cantanhede"
        "Cluster"     = "Logstash"
      }
      template_disk_sizes          = [21, 80, 7]
      template_disk_io_reservation = [0, 0, 0]
      data_disk                    = {}
    }
  }
}

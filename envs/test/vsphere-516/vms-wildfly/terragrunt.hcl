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

    "TSAP01" = {
      template          = "default-template-alma-9.6-base"
      instances         = 1
      vmstartcount      = 1
      staticvmname      = "TSAP01"
      datacenter        = "SOF"
      datastore_cluster = "Purestorage_Default"
      resource_pool     = "Blade_Kratos/Resources"
      vsphere_cluster   = "Blade_Kratos"
      domain            = "sof.intra"
      network           = { "PG_Gaia_Teste" = ["192.168.30.131"] }
      dns_server_list   = []
      mask              = ["24"]
      gateway           = "192.168.30.1"
      cpu               = 4
      memory            = 13312
      local_adminpass   = "${local.TF_VAR_VM_PASS}"
      distro            = "${local.TF_VAR_DISTRO}"
      network_type      = ["vmxnet3"]
      annotation        = "Servidor de Testes Wildfly - 18/04/2026 - Rogerio Vieira"
      tags = {
        "Origem"       = "Terraform"
        "Ambiente"     = "Test"
        "Aplicacao"    = "Wildfly"
        "Responsavel"  = "Rogerio Vieira Silva"
      }
      template_disk_io_reservation = [1, 1, 1]
      data_disk                    = {}
    }

    "TSAP02-WILDFLY" = {
      template          = "default-template-alma-9.6-base"
      instances         = 1
      vmstartcount      = 2
      staticvmname      = "TSAP02-WILDFLY"
      datacenter        = "SOF"
      datastore_cluster = "Purestorage_Default"
      resource_pool     = "Blade_Kratos/Resources"
      vsphere_cluster   = "Blade_Kratos"
      domain            = "sof.intra"
      network           = { "PG_Gaia_Teste" = ["192.168.30.128"] }
      dns_server_list   = []
      mask              = ["24"]
      gateway           = "192.168.30.1"
      cpu               = 4
      memory            = 13312
      local_adminpass   = "${local.TF_VAR_VM_PASS}"
      distro            = "${local.TF_VAR_DISTRO}"
      network_type      = ["vmxnet3"]
      annotation        = "Servidor de Testes Wildfly - 18/04/2026 - Rogerio Vieira"
      tags = {
        "Origem"       = "Terraform"
        "Ambiente"     = "Test"
        "Aplicacao"    = "Wildfly"
        "Responsavel"  = "Rogerio Vieira Silva"
      }
      template_disk_io_reservation = [1, 1, 1]
      data_disk                    = {}
    }

    "TSAP03-WILDFLY" = {
      template          = "default-template-alma-9.6-base"
      instances         = 1
      vmstartcount      = 3
      staticvmname      = "TSAP03-WILDFLY"
      datacenter        = "SOF"
      datastore_cluster = "Purestorage_Default"
      resource_pool     = "Blade_Kratos/Resources"
      vsphere_cluster   = "Blade_Kratos"
      domain            = "sof.intra"
      network           = { "PG_Gaia_Teste" = ["192.168.30.138"] }
      dns_server_list   = []
      mask              = ["24"]
      gateway           = "192.168.30.1"
      cpu               = 4
      memory            = 13312
      local_adminpass   = "${local.TF_VAR_VM_PASS}"
      distro            = "${local.TF_VAR_DISTRO}"
      network_type      = ["vmxnet3"]
      annotation        = "Servidor de Testes Wildfly - 18/04/2026 - Rogerio Vieira"
      tags = {
        "Origem"       = "Terraform"
        "Ambiente"     = "Test"
        "Aplicacao"    = "Wildfly"
        "Responsavel"  = "Rogerio Vieira Silva"
      }
      template_disk_io_reservation = [1, 1, 1]
      data_disk                    = {}
    }

    "TSAP04-WILDFLY" = {
      template          = "default-template-alma-9.6-base"
      instances         = 1
      vmstartcount      = 4
      staticvmname      = "TSAP04-WILDFLY"
      datacenter        = "SOF"
      datastore_cluster = "Purestorage_Default"
      resource_pool     = "Blade_Kratos/Resources"
      vsphere_cluster   = "Blade_Kratos"
      domain            = "sof.intra"
      network           = { "PG_Gaia_Teste" = ["192.168.30.139"] }
      dns_server_list   = []
      mask              = ["24"]
      gateway           = "192.168.30.1"
      cpu               = 4
      memory            = 13312
      local_adminpass   = "${local.TF_VAR_VM_PASS}"
      distro            = "${local.TF_VAR_DISTRO}"
      network_type      = ["vmxnet3"]
      annotation        = "Servidor de Testes Wildfly - 18/04/2026 - Rogerio Vieira"
      tags = {
        "Origem"       = "Terraform"
        "Ambiente"     = "Test"
        "Aplicacao"    = "Wildfly"
        "Responsavel"  = "Rogerio Vieira Silva"
      }
      template_disk_io_reservation = [1, 1, 1]
      data_disk                    = {}
    }

    "TSAP05-WILDFLY" = {
      template          = "default-template-alma-9.6-base"
      instances         = 1
      vmstartcount      = 5
      staticvmname      = "TSAP05-WILDFLY"
      datacenter        = "SOF"
      datastore_cluster = "Purestorage_Default"
      resource_pool     = "Blade_Kratos/Resources"
      vsphere_cluster   = "Blade_Kratos"
      domain            = "sof.intra"
      network           = { "PG_Gaia_Teste" = ["192.168.30.144"] }
      dns_server_list   = []
      mask              = ["24"]
      gateway           = "192.168.30.1"
      cpu               = 4
      memory            = 13312
      local_adminpass   = "${local.TF_VAR_VM_PASS}"
      distro            = "${local.TF_VAR_DISTRO}"
      network_type      = ["vmxnet3"]
      annotation        = "Servidor de Testes Wildfly - 18/04/2026 - Rogerio Vieira"
      tags = {
        "Origem"       = "Terraform"
        "Ambiente"     = "Test"
        "Aplicacao"    = "Wildfly"
        "Responsavel"  = "Rogerio Vieira Silva"
      }
      template_disk_io_reservation = [1, 1, 1]
      data_disk                    = {}
    }

    "TSAP06-WILDFLY" = {
      template          = "default-template-alma-9.6-base"
      instances         = 1
      vmstartcount      = 6
      staticvmname      = "TSAP06-WILDFLY"
      datacenter        = "SOF"
      datastore_cluster = "Purestorage_Default"
      resource_pool     = "Blade_Kratos/Resources"
      vsphere_cluster   = "Blade_Kratos"
      domain            = "sof.intra"
      network           = { "PG_Gaia_Teste" = ["192.168.30.145"] }
      dns_server_list   = []
      mask              = ["24"]
      gateway           = "192.168.30.1"
      cpu               = 4
      memory            = 13312
      local_adminpass   = "${local.TF_VAR_VM_PASS}"
      distro            = "${local.TF_VAR_DISTRO}"
      network_type      = ["vmxnet3"]
      annotation        = "Servidor de Testes Wildfly - 18/04/2026 - Rogerio Vieira"
      tags = {
        "Origem"       = "Terraform"
        "Ambiente"     = "Test"
        "Aplicacao"    = "Wildfly"
        "Responsavel"  = "Rogerio Vieira Silva"
      }
      template_disk_io_reservation = [1, 1, 1]
      data_disk                    = {}
    }

    "TSAP07" = {
      template          = "default-template-alma-9.6-base"
      instances         = 1
      vmstartcount      = 7
      staticvmname      = "TSAP07"
      datacenter        = "SOF"
      datastore_cluster = "Purestorage_Default"
      resource_pool     = "Blade_Kratos/Resources"
      vsphere_cluster   = "Blade_Kratos"
      domain            = "sof.intra"
      network           = { "PG_Gaia_Teste" = ["192.168.30.208"] }
      dns_server_list   = []
      mask              = ["24"]
      gateway           = "192.168.30.1"
      cpu               = 4
      memory            = 13312
      local_adminpass   = "${local.TF_VAR_VM_PASS}"
      distro            = "${local.TF_VAR_DISTRO}"
      network_type      = ["vmxnet3"]
      annotation        = "Servidor de Testes Wildfly - 18/04/2026 - Rogerio Vieira"
      tags = {
        "Origem"       = "Terraform"
        "Ambiente"     = "Test"
        "Aplicacao"    = "Wildfly"
        "Responsavel"  = "Rogerio Vieira Silva"
      }
      template_disk_io_reservation = [1, 1, 1]
      data_disk                    = {}
    }

    "TSAP08-WILDFLY" = {
      template          = "default-template-alma-9.6-base"
      instances         = 1
      vmstartcount      = 7
      staticvmname      = "TSAP08-WILDFLY"
      datacenter        = "SOF"
      datastore_cluster = "Purestorage_Default"
      resource_pool     = "Blade_Kratos/Resources"
      vsphere_cluster   = "Blade_Kratos"
      domain            = "sof.intra"
      network           = { "PG_Gaia_Teste" = ["192.168.30.209"] }
      dns_server_list   = []
      mask              = ["24"]
      gateway           = "192.168.30.1"
      cpu               = 4
      memory            = 13312
      local_adminpass   = "${local.TF_VAR_VM_PASS}"
      distro            = "${local.TF_VAR_DISTRO}"
      network_type      = ["vmxnet3"]
      annotation        = "Servidor de Testes Wildfly - 18/04/2026 - Rogerio Vieira"
      tags = {
        "Origem"       = "Terraform"
        "Ambiente"     = "Test"
        "Aplicacao"    = "Wildfly"
        "Responsavel"  = "Rogerio Vieira Silva"
      }
      template_disk_io_reservation = [1, 1, 1]
      data_disk                    = {}
    }


    "TSAP09-WILDFLY" = {
      template          = "default-template-alma-9.6-base"
      instances         = 1
      vmstartcount      = 9
      staticvmname      = "TSAP09-WILDFLY"
      datacenter        = "SOF"
      datastore_cluster = "Purestorage_Default"
      resource_pool     = "Blade_Kratos/Resources"
      vsphere_cluster   = "Blade_Kratos"
      domain            = "sof.intra"
      network           = { "PG_Gaia_Teste" = ["192.168.30.157"] }
      dns_server_list   = []
      mask              = ["24"]
      gateway           = "192.168.30.1"
      cpu               = 4
      memory            = 13312
      local_adminpass   = "${local.TF_VAR_VM_PASS}"
      distro            = "${local.TF_VAR_DISTRO}"
      network_type      = ["vmxnet3"]
      annotation        = "Servidor de Testes Wildfly - 18/04/2026 - Rogerio Vieira"
      tags = {
        "Origem"       = "Terraform"
        "Ambiente"     = "Test"
        "Aplicacao"    = "Wildfly"
        "Responsavel"  = "Rogerio Vieira Silva"
      }
      template_disk_io_reservation = [1, 1, 1]
      data_disk                    = {}
    }

    "TSAP10-WILDFLY" = {
      template          = "default-template-alma-9.6-base"
      instances         = 1
      vmstartcount      = 10
      staticvmname      = "TSAP10-WILDFLY"
      datacenter        = "SOF"
      datastore_cluster = "Purestorage_Default"
      resource_pool     = "Blade_Kratos/Resources"
      vsphere_cluster   = "Blade_Kratos"
      domain            = "sof.intra"
      network           = { "PG_Gaia_Teste" = ["192.168.30.158"] }
      dns_server_list   = []
      mask              = ["24"]
      gateway           = "192.168.30.1"
      cpu               = 4
      memory            = 13312
      local_adminpass   = "${local.TF_VAR_VM_PASS}"
      distro            = "${local.TF_VAR_DISTRO}"
      network_type      = ["vmxnet3"]
      annotation        = "Servidor de Testes Wildfly - 18/04/2026 - Rogerio Vieira"
      tags = {
        "Origem"       = "Terraform"
        "Ambiente"     = "Test"
        "Aplicacao"    = "Wildfly"
        "Responsavel"  = "Rogerio Vieira Silva"
      }
      template_disk_io_reservation = [1, 1, 1]
      data_disk                    = {}
    }

    "TSAP20-WILDFLY" = {
      template          = "default-template-alma-9.6-base"
      instances         = 1
      vmstartcount      = 20
      staticvmname      = "TSAP20-WILDFLY"
      datacenter        = "SOF"
      datastore_cluster = "Purestorage_Default"
      resource_pool     = "Blade_Kratos/Resources"
      vsphere_cluster   = "Blade_Kratos"
      domain            = "sof.intra"
      network           = { "PG_Gaia_Teste" = ["192.168.30.159"] }
      dns_server_list   = []
      mask              = ["24"]
      gateway           = "192.168.30.1"
      cpu               = 4
      memory            = 13312
      local_adminpass   = "${local.TF_VAR_VM_PASS}"
      distro            = "${local.TF_VAR_DISTRO}"
      network_type      = ["vmxnet3"]
      annotation        = "Servidor de Testes Wildfly - 18/04/2026 - Rogerio Vieira"
      tags = {
        "Origem"       = "Terraform"
        "Ambiente"     = "Test"
        "Aplicacao"    = "Wildfly"
        "Responsavel"  = "Rogerio Vieira Silva"
      }
      template_disk_io_reservation = [1, 1, 1]
      data_disk                    = {}
    }

  }
}
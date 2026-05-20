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

    "PSAP01-WILDFLY" = {
      template          = "default-template-alma-9.6-base"
      instances         = 1
      vmstartcount      = 1
      staticvmname      = "PSAP01-WILDFLY"
      datacenter        = "SOF"
      datastore_cluster = "Purestorage_Default"
      resource_pool     = "Blade_Kratos/Resources"
      vsphere_cluster   = "Blade_Kratos"
      domain            = "sof.intra"
      network           = { "PG_Gaia_DMZ_Servico_Producao" = ["192.168.20.41"] }
      dns_server_list   = []
      mask              = ["24"]
      gateway           = "192.168.20.1"
      cpu               = 4
      memory            = 13312
      local_adminpass   = "${local.TF_VAR_VM_PASS}"
      distro            = "${local.TF_VAR_DISTRO}"
      network_type      = ["vmxnet3"]
      annotation        = "Servidor de Producao Wildfly - 14/05/2026 - Rogerio Vieira"
      tags = {
        "Origem"       = "Terraform"
        "Ambiente"     = "Prod"
        "Aplicacao"    = "Wildfly"
        "Responsavel"  = "Rogerio Vieira Silva"
      }
      template_disk_io_reservation = [1, 1, 1]
      data_disk                    = {}
    }

    "PSAP02-WILDFLY" = {
      template          = "default-template-alma-9.6-base"
      instances         = 1
      vmstartcount      = 2
      staticvmname      = "PSAP02-WILDFLY"
      datacenter        = "SOF"
      datastore_cluster = "Purestorage_Default"
      resource_pool     = "Blade_Kratos/Resources"
      vsphere_cluster   = "Blade_Kratos"
      domain            = "sof.intra"
      network           = { "PG_Gaia_DMZ_Servico_Producao" = ["192.168.20.42"] }
      dns_server_list   = []
      mask              = ["24"]
      gateway           = "192.168.20.1"
      cpu               = 4
      memory            = 13312
      local_adminpass   = "${local.TF_VAR_VM_PASS}"
      distro            = "${local.TF_VAR_DISTRO}"
      network_type      = ["vmxnet3"]
      annotation        = "Servidor de Producao Wildfly - 14/05/2026 - Rogerio Vieira"
      tags = {
        "Origem"       = "Terraform"
        "Ambiente"     = "Prod"
        "Aplicacao"    = "Wildfly"
        "Responsavel"  = "Rogerio Vieira Silva"
      }
      template_disk_io_reservation = [1, 1, 1]
      data_disk                    = {}
    }

    "PSAP03-WILDFLY" = {
      template          = "default-template-alma-9.6-base"
      instances         = 1
      vmstartcount      = 3
      staticvmname      = "PSAP03-WILDFLY"
      datacenter        = "SOF"
      datastore_cluster = "Purestorage_Default"
      resource_pool     = "Blade_Kratos/Resources"
      vsphere_cluster   = "Blade_Kratos"
      domain            = "sof.intra"
      network           = { "PG_Gaia_DMZ_Servico_Producao" = ["192.168.20.44"] }
      dns_server_list   = []
      mask              = ["24"]
      gateway           = "192.168.20.1"
      cpu               = 4
      memory            = 13312
      local_adminpass   = "${local.TF_VAR_VM_PASS}"
      distro            = "${local.TF_VAR_DISTRO}"
      network_type      = ["vmxnet3"]
      annotation        = "Servidor de Producao Wildfly - 14/05/2026 - Rogerio Vieira"
      tags = {
        "Origem"       = "Terraform"
        "Ambiente"     = "Prod"
        "Aplicacao"    = "Wildfly"
        "Responsavel"  = "Rogerio Vieira Silva"
      }
      template_disk_io_reservation = [1, 1, 1]
      data_disk                    = {}
    }

    "PSAP04-WILDFLY" = {
      template          = "default-template-alma-9.6-base"
      instances         = 1
      vmstartcount      = 4
      staticvmname      = "PSAP04-WILDFLY"
      datacenter        = "SOF"
      datastore_cluster = "Purestorage_Default"
      resource_pool     = "Blade_Kratos/Resources"
      vsphere_cluster   = "Blade_Kratos"
      domain            = "sof.intra"
      network           = { "PG_Gaia_DMZ_Servico_Producao" = ["192.168.20.46"] }
      dns_server_list   = []
      mask              = ["24"]
      gateway           = "192.168.20.1"
      cpu               = 4
      memory            = 13312
      local_adminpass   = "${local.TF_VAR_VM_PASS}"
      distro            = "${local.TF_VAR_DISTRO}"
      network_type      = ["vmxnet3"]
      annotation        = "Servidor de Producao Wildfly - 14/05/2026 - Rogerio Vieira"
      tags = {
        "Origem"       = "Terraform"
        "Ambiente"     = "Prod"
        "Aplicacao"    = "Wildfly"
        "Responsavel"  = "Rogerio Vieira Silva"
      }
      template_disk_io_reservation = [1, 1, 1]
      data_disk                    = {}
    }

    # IP pendente de definição
    "LSAP01-WILDFLY" = {
      template          = "default-template-alma-9.6-base"
      instances         = 1
      vmstartcount      = 1
      staticvmname      = "LSAP01-WILDFLY"
      datacenter        = "SOF"
      datastore_cluster = "Purestorage_Default"
      resource_pool     = "Blade_Kratos/Resources"
      vsphere_cluster   = "Blade_Kratos"
      domain            = "sof.intra"
      network           = { "PG_Gaia_DMZ_Servico_Producao" = ["192.168.20.47"] }
      dns_server_list   = []
      mask              = ["24"]
      gateway           = "192.168.20.1"
      cpu               = 4
      memory            = 13312
      local_adminpass   = "${local.TF_VAR_VM_PASS}"
      distro            = "${local.TF_VAR_DISTRO}"
      network_type      = ["vmxnet3"]
      annotation        = "Servidor de Producao Wildfly - 14/05/2026 - Rogerio Vieira"
      tags = {
        "Origem"       = "Terraform"
        "Ambiente"     = "Prod"
        "Aplicacao"    = "Wildfly"
        "Responsavel"  = "Rogerio Vieira Silva"
      }
      template_disk_io_reservation = [1, 1, 1]
      data_disk                    = {}
    }

    # IP pendente de definição
    "PSAP10-WILDFLY" = {
      template          = "default-template-alma-9.6-base"
      instances         = 1
      vmstartcount      = 1
      staticvmname      = "LSAP01-WILDFLY"
      datacenter        = "SOF"
      datastore_cluster = "Purestorage_Default"
      resource_pool     = "Blade_Kratos/Resources"
      vsphere_cluster   = "Blade_Kratos"
      domain            = "sof.intra"
      network           = { "PG_Gaia_DMZ_Servico_Producao" = ["192.168.20.52"] }
      dns_server_list   = []
      mask              = ["24"]
      gateway           = "192.168.20.1"
      cpu               = 4
      memory            = 13312
      local_adminpass   = "${local.TF_VAR_VM_PASS}"
      distro            = "${local.TF_VAR_DISTRO}"
      network_type      = ["vmxnet3"]
      annotation        = "Servidor de Producao Wildfly - 14/05/2026 - Rogerio Vieira"
      tags = {
        "Origem"       = "Terraform"
        "Ambiente"     = "Prod"
        "Aplicacao"    = "Wildfly"
        "Responsavel"  = "Rogerio Vieira Silva"
      }
      template_disk_io_reservation = [1, 1, 1]
      data_disk                    = {}
    }

    # IP pendente de definição
#    "HSAP01-WILDFLY" = {
#      template          = "default-template-alma-9.6-base"
#      instances         = 1
#      vmstartcount      = 1
#      staticvmname      = "HSAP01-WILDFLY"
#      datacenter        = "SOF"
#      datastore_cluster = "Purestorage_Default"
#      resource_pool     = "Blade_Kratos/Resources"
#      vsphere_cluster   = "Blade_Kratos"
#      domain            = "sof.intra"
#      network           = { "PG_Gaia_DMZ_Servico_Homolocacao" = ["192.168.40.20"] }
#      dns_server_list   = []
#      mask              = ["24"]
#      gateway           = "192.168.40.1"
#      cpu               = 4
#      memory            = 13312
#      local_adminpass   = "${local.TF_VAR_VM_PASS}"
#      distro            = "${local.TF_VAR_DISTRO}"
#      network_type      = ["vmxnet3"]
#      annotation        = "Servidor de Producao Wildfly - 14/05/2026 - Rogerio Vieira"
#      tags = {
#        "Origem"       = "Terraform"
#        "Ambiente"     = "Prod"
#        "Aplicacao"    = "Wildfly"
#        "Responsavel"  = "Rogerio Vieira Silva"
#      }
#      template_disk_io_reservation = [1, 1, 1]
#      data_disk                    = {}
#    }

  }
}

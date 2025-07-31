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
    "PIAO01" = {
      template        = "default_template_almalinux_10_base"
      staticvmname    = "PIAO01"
      instances       = 1
      vmstartcount    = 0
      datacenter      = "SOF"
      datastore_cluster = "Purestorage_Default"
      datastore       = "Purestorage_Default"
      resource_pool   = "Blade_Kratos/Resources"
      vsphere_cluster = "Blade_Kratos"
      domain          = "sof.intra"
      network         = {"PG_Gaia_Teste" = ["192.168.30.11"]}
      dns_server_list = ["172.27.3.5", "172.27.3.6"]
      mask            = ["24"]
      gateway         = "192.168.30.1"
      cpu             = 8
      memory          = 16384
      local_adminpass = "${local.TF_VAR_VM_PASS}"
      distro          = "${local.TF_VAR_DISTRO}"
      network_type    = ["vmxnet3"]
      annotation      = "Inteligência Artificial para Operações de TI - AIOps"
      tags = { }
      data_disk = {
        "disk_A1" = {
          size_gb          = 200
          unit_number      = 3
          thin_provisioned = true
          eagerly_scrub    = false
          storage_policy_id = null
          io_reservation   = null
          io_share_level   = "normal"
          disk_mode        = null
          disk_sharing     = null
          attach           = null
          path             = null
        }
      }
    },
    "PIAO02" = {
      template        = "default_template_almalinux_10_base"
      staticvmname    = "PIAO02"
      instances       = 1
      vmstartcount    = 0
      datacenter      = "SOF"
      datastore_cluster = "Purestorage_Default"
      datastore       = "Purestorage_Default"
      resource_pool   = "Blade_Kratos/Resources"
      vsphere_cluster = "Blade_Kratos"
      domain          = "sof.intra"
      network         = {"PG_Gaia_Teste" = ["192.168.30.12"]}
      dns_server_list = ["172.27.3.5", "172.27.3.6"]
      mask            = ["24"]
      gateway         = "192.168.30.1"
      cpu             = 8
      memory          = 16384
      local_adminpass = "${local.TF_VAR_VM_PASS}"
      distro          = "${local.TF_VAR_DISTRO}"
      network_type    = ["vmxnet3"]
      annotation      = "Inteligência Artificial para Operações de TI - AIOps"
      tags = { }
      data_disk = {
        "disk_A1" = {
          size_gb          = 500
          unit_number      = 3
          thin_provisioned = true
          eagerly_scrub    = false
          storage_policy_id = null
          io_reservation   = null
          io_share_level   = "normal"
          disk_mode        = null
          disk_sharing     = null
          attach           = null
          path             = null
        }
      }
    },
    "PIAO03" = {
      template        = "default_template_almalinux_10_base"
     staticvmname    = "PIAO03"
      instances       = 1
      vmstartcount    = 0
      datacenter      = "SOF"
      datastore_cluster = "Purestorage_Default"
      datastore       = "Purestorage_Default"
      resource_pool   = "Blade_Kratos/Resources"
      vsphere_cluster = "Blade_Kratos"
      domain          = "sof.intra"
      network         = {"PG_Gaia_Teste" = ["192.168.30.15"]}
      dns_server_list = ["172.27.3.5", "172.27.3.6"]
      mask            = ["24"]
      gateway         = "192.168.30.1"
      cpu             = 4
      memory          = 8192
      local_adminpass = "${local.TF_VAR_VM_PASS}"
      distro          = "${local.TF_VAR_DISTRO}"
      network_type    = ["vmxnet3"]
      annotation      = "Inteligência Artificial para Operações de TI - AIOps"
      tags = { }
      data_disk = {
        "disk_A1" = {
          size_gb          = 50
          unit_number      = 3
          thin_provisioned = true
          eagerly_scrub    = false
          storage_policy_id = null
          io_reservation   = null
          io_share_level   = "normal"
          disk_mode        = null
          disk_sharing     = null
          attach           = null
          path             = null
        }
      }
    },
    "PIAO04" = {
      template        = "default_template_almalinux_10_base"
      staticvmname    = "PIAO04"
      instances       = 1
      vmstartcount    = 0
      datacenter      = "SOF"
      datastore_cluster = "Purestorage_Default"
      datastore       = "Purestorage_Default"
      resource_pool   = "Blade_Kratos/Resources"
      vsphere_cluster = "Blade_Kratos"
      domain          = "sof.intra"
      network         = {"PG_Gaia_Teste" = ["192.168.30.18"]}
      dns_server_list = ["172.27.3.5", "172.27.3.6"]
      mask            = ["24"]
      gateway         = "192.168.30.1"
      cpu             = 8
      memory          = 16384
      local_adminpass = "${local.TF_VAR_VM_PASS}"
      distro          = "${local.TF_VAR_DISTRO}"
      network_type    = ["vmxnet3"]
      annotation      = "Inteligência Artificial para Operações de TI - AIOps"
      tags = { }
      data_disk = {
        "disk_A1" = {
          size_gb          = 500
          unit_number      = 3
          thin_provisioned = true
          eagerly_scrub    = false
          storage_policy_id = null
          io_reservation   = null
          io_share_level   = "normal"
          disk_mode        = null
          disk_sharing     = null
          attach           = null
          path             = null
        }
      }
    }
  }
}
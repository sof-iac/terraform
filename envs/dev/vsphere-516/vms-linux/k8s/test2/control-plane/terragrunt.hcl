include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../../../../../modules/vsphere/vm/linux"  # Caminho relativo ao terragrunt.hcl
}

locals {
  TF_VAR_VM_PASS = get_env("TF_VAR_VM_PASS")
  TF_VAR_DISTRO  = get_env("TF_VAR_DISTRO")
}

inputs = {
  vm = {
    "TKBN" = {
      template          = "ubuntu2204-packer-template-base"
      instances         = 5
      vmstartcount      = 70
      datacenter        = "SOF"
      datastore_cluster = "Storage_Purestorage"
      datastore         = "Storage_Purestorage"
      resource_pool     = "Blade_Kratos/Resources"
      vsphere_cluster   = "Blade_Kratos"
      network           = {"PG_Gaia_Kubestag" = ["192.168.21.70", "192.168.21.71", "192.168.21.72", "192.168.21.73", "192.168.21.74"]}
      dns_server_list   = ["172.27.3.5", "172.27.3.6"]
      mask              = ["24"]
      gateway           = "192.168.21.1"
      cpu               = 4
      memory            = 16348
      domain            = "sof.intra"
      local_adminpass   = "${local.TF_VAR_VM_PASS}"
      distro            = "${local.TF_VAR_DISTRO}"
      network_type      = ["vmxnet3"]
      annotation        = "Node cluster k8s de test"
      tags = {
        "Origem"    = "Terraform"
        "Ambiente"  = "dev"
        "Aplicacao" = "kubernetes"
      }
      # Adicionando discos adicionais
      data_disk = {
        "disk_A1" = {
          size_gb                = 35
          unit_number            = 3
          thin_provisioned       = true
          eagerly_scrub          = false
          # datastore_id           = "Storage_Purestorage"
          storage_policy_id      = null
          io_reservation         = null
          io_share_level         = "normal"
          disk_mode              = null
          disk_sharing           = null
          attach                 = null
          path                   = null
        }
      }
    }
  }
}

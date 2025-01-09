terraform {
  source = "../../../../modules/vsphere/storage"
}

include {
  path = find_in_parent_folders()
}

dependency "datacenter-config" {
  config_path = "../datacenter-config"
}

dependency "host-resources" {
  config_path = "../host-resources"
}

inputs = {
  datastore = {
    "PHST41_K_LOCAL" = {
      folder  = "Disco_Local_SEM_USO"
      host-id = dependency.host-resources.outputs.hosts["phst41.blocok.sof.remoto"].id
      disks   = ["naa.6d094660214a0400220537e31115efd3"]
      tags    = []
    }
    "PHST42_K_LOCAL" = {
      folder  = "Disco_Local_SEM_USO"
      host-id = dependency.host-resources.outputs.hosts["phst42.blocok.sof.remoto"].id
      disks   = ["naa.6d0946602149da002203231711abb67a"]
      tags    = []
    }
    "PHST43_K_LOCAL" = {
      folder  = "Disco_Local_SEM_USO"
      host-id = dependency.host-resources.outputs.hosts["phst43.blocok.sof.remoto"].id
      disks   = ["naa.6d0946602149fa002203239314112675"]
      tags    = []
    }
    "PHST44_K_LOCAL" = {
      folder  = "Disco_Local_SEM_USO"
      host-id = dependency.host-resources.outputs.hosts["phst44.blocok.sof.remoto"].id
      disks   = ["naa.6d094660214729002203232314ddb33a"]
      tags    = []
    }
    "Lun1_BLOCOK_5TB" = {
      host-id = dependency.host-resources.outputs.hosts["phst41.blocok.sof.remoto"].id
      disks   = ["naa.600601603f803c00eb3de9cac156ec11"]
      tags    = []
    }
    "Lun2_BLOCOK_5TB" = {
      host-id = dependency.host-resources.outputs.hosts["phst41.blocok.sof.remoto"].id
      disks   = ["naa.600601603f803c00ed3de9cac156ec11"]
      tags    = ["urn:vmomi:InventoryServiceTag:6aab0367-6402-44c1-b966-5eac7ba3dc51:GLOBAL"]
    }
  }

  datastore-cluster = {
  }
}


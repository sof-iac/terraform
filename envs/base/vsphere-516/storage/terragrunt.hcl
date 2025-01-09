terraform {
  source = "../../../../modules/vsphere/host-resources"
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
  }
  datastore-cluster = {
    "Storage_Purestorage" = {
      sdrs = {
        enabled                        = true
        automation-level               = "automated"
        free-space-utilization-diff    = 10
        io-balance-automation-level    = "manual"
        io-latency-threshold           = 25
        io-load-imbalance-threshold    = 20
        load-balance-interval          = 360
        space-balance-automation-level = null
        space-utilization-threshold    = 80
      }
      tags = null
    }
  }
}


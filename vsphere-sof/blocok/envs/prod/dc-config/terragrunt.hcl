include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../../../modules/vsphere/datacenter-config"
}

inputs = {
  datacenter = {
    dc-name = "BLOCOK"
    tags    = [] 
  }

  datastore-cluster = {
  }

  compute-cluster = {
    "Blade_DTI" = {
      host-ids = [
        "host-50",
        "host-54",
        "host-58",
        "host-62"
      ]
      drs  = {
        enabled          = true
        automation-level = "fullyAutomated"
        advanced-options = {} 
      }
      dpm = {
        enabled          = false
        automation-level = "automated"
      }
      ha   = {
        enabled                       = true
        datastore-apd-recovery-action = "none"
        datastore-apd-response        = "restartConservative"
        datastore-apd-response-delay  = 180
        datastore-pdl-response        = "restartAggressive"
        vm-maximum-failure-window     = -1
        advanced-options = {}
      }
      tags = null
    }
  }
  
  resource-pool = {
    "Infra_BlocoK" = {
      compute-cluster          = "Blade_DTI"
      cpu-share-level          = "high"
      memory-share-level       = "high"
      scale-descendants-shares = "disabled"
    }
    "VMware_BlocoK" = {
      compute-cluster          = "Blade_DTI"
      cpu-share-level          = "high"
      memory-share-level       = "high"
      scale-descendants-shares = "disabled"
    }
  }
}


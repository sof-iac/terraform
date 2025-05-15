terraform {
  source = "../../../../modules/vsphere/host-resources"
}

include {
  path = find_in_parent_folders()
}

dependency "datacenter-config" {
  config_path = "../datacenter-config"
}

inputs = {
  host = {
    "phst41.blocok.sof.remoto" = {
      username        = "root"
      password        = "xxxx"
      license         = "JJ21N-4E15Q-083N0-0GCA0-AJE3M"
      cluster-managed = true
      
      services = {
        enabled     = true
        policy      = "on"
        ntp-servers = [
          "192.168.250.201"
        ]
      }
    }
    "phst42.blocok.sof.remoto" = {
      username        = "root"
      password        = "xxxx"
      license         = "JJ21N-4E15Q-083N0-0GCA0-AJE3M"
      cluster-managed = true
      
      services = {
        enabled     = true
        policy      = "on"
        ntp-servers = [
          "192.168.250.201"
        ]
      }
    }
    "phst43.blocok.sof.remoto" = {
      username        = "root"
      password        = "xxxx"
      license         = "JJ21N-4E15Q-083N0-0GCA0-AJE3M"
      cluster-managed = true
      
      services = {
        enabled     = true
        policy      = "on"
        ntp-servers = [
          "192.168.250.201"
        ]
      }
    }
    "phst44.blocok.sof.remoto" = {
      username        = "root"
      password        = "xxxx"
      license         = "JJ21N-4E15Q-083N0-0GCA0-AJE3M"
      cluster-managed = true
      
      services = {
        enabled     = true
        policy      = "on"
        ntp-servers = [
          "192.168.250.201"
        ]
      }
    }
  }

  compute-cluster = {
    "Blade_DTI" = {
      datacenter-id = dependency.datacenter-config.outputs.dc_id
      hosts         = [
        "phst41.blocok.sof.remoto",
        "phst42.blocok.sof.remoto",
        "phst43.blocok.sof.remoto",
        "phst44.blocok.sof.remoto"
      ]
      drs           = {
        enabled          = true
        automation-level = "fullyAutomated"
        advanced-options = {} 
      }
      dpm           = {
        enabled          = false
        automation-level = "automated"
      }
      ha            = {
        enabled                       = true
        datastore-apd-recovery-action = "none"
        datastore-apd-response        = "restartConservative"
        datastore-apd-response-delay  = 180
        datastore-pdl-response        = "restartAggressive"
        vm-maximum-failure-window     = -1
        advanced-options = {}
      }
      tags          = null
    }
  }
  
  resource-pool = {
    "VMware_BlocoK" = {
      compute-cluster          = "Blade_DTI"
      cpu-share-level          = "high"
      memory-share-level       = "high"
      scale-descendants-shares = "disabled"
    }
  }
}


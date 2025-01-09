terraform {
  source = "../../../../modules/vsphere/host-resources"
}

include {
  path = find_in_parent_folders()
}

dependency "datacenter-config" {
  config_path = "../datacenter-config"
}

locals {
  root-passwd = get_env("TF_VAR_passwd_root_phst_516")
}

inputs = {
  host = {
    "phst31.sof.intra" = {
      username        = "root"
      password        = "${local.root-passwd}"
      license         = "1M284-8YJ4Q-L878M-08KA2-1D1N4"
      cluster-managed = true
      
      services = {
        enabled     = true
        policy      = "on"
        ntp-servers = [
          "192.168.250.201"
        ]
      }
    }
    "phst32.sof.intra" = {
      username        = "root"
      password        = "${local.root-passwd}"
      license         = "1M284-8YJ4Q-L878M-08KA2-1D1N4"
      cluster-managed = true
      
      services = {
        enabled     = true
        policy      = "on"
        ntp-servers = [
          "192.168.250.201"
        ]
      }
    }
    "phst33.sof.intra" = {
      username        = "root"
      password        = "${local.root-passwd}"
      license         = "1M284-8YJ4Q-L878M-08KA2-1D1N4"
      cluster-managed = true
      
      services = {
        enabled     = true
        policy      = "on"
        ntp-servers = [
          "192.168.250.201"
        ]
      }
    }
    "phst34.sof.intra" = {
      username        = "root"
      password        = "${local.root-passwd}"
      license         = "1M284-8YJ4Q-L878M-08KA2-1D1N4"
      cluster-managed = true
      
      services = {
        enabled     = true
        policy      = "on"
        ntp-servers = [
          "192.168.250.201"
        ]
      }
    }
    "phst35.sof.intra" = {
      username        = "root"
      password        = "${local.root-passwd}"
      license         = "1M284-8YJ4Q-L878M-08KA2-1D1N4"
      cluster-managed = true
      
      services = {
        enabled     = true
        policy      = "on"
        ntp-servers = [
          "192.168.250.201"
        ]
      }
    }
    "phst36.sof.intra" = {
      username        = "root"
      password        = "${local.root-passwd}"
      license         = "1M284-8YJ4Q-L878M-08KA2-1D1N4"
      cluster-managed = true
      
      services = {
        enabled     = true
        policy      = "on"
        ntp-servers = [
          "192.168.250.201"
        ]
      }
    }
    "phst37.sof.intra" = {
      username        = "root"
      password        = "${local.root-passwd}"
      license         = "1M284-8YJ4Q-L878M-08KA2-1D1N4"
      cluster-managed = true
      
      services = {
        enabled     = true
        policy      = "off"
        ntp-servers = [
          "192.168.250.201"
        ]
      }
    }
    "phst38.sof.intra" = {
      username        = "root"
      password        = "${local.root-passwd}"
      license         = "1M284-8YJ4Q-L878M-08KA2-1D1N4"
      cluster-managed = true
      
      services = {
        enabled     = true
        policy      = "on"
        ntp-servers = [
          "192.168.250.201"
        ]
      }
    }
    "phst41.sof.intra" = {
      username        = "root"
      password        = "${local.root-passwd}"
      license         = "NM29Q-0EJDN-08VN8-0W8RP-8EZQN"
      cluster-managed = true
      
      services = {
        enabled     = true
        policy      = "on"
        ntp-servers = [
          "192.168.250.201"
        ]
      }
    }
    "phst42.sof.intra" = {
      username        = "root"
      password        = "${local.root-passwd}"
      license         = "NM29Q-0EJDN-08VN8-0W8RP-8EZQN"
      cluster-managed = true
      
      services = {
        enabled     = true
        policy      = "on"
        ntp-servers = [
          "192.168.250.201"
        ]
      }
    }
    "phst43.sof.intra" = {
      username        = "root"
      password        = "${local.root-passwd}"
      license         = "NM29Q-0EJDN-08VN8-0W8RP-8EZQN"
      cluster-managed = true
      
      services = {
        enabled     = true
        policy      = "on"
        ntp-servers = [
          "192.168.250.201"
        ]
      }
    }
    "phst44.sof.intra" = {
      username        = "root"
      password        = "${local.root-passwd}"
      license         = "NM29Q-0EJDN-08VN8-0W8RP-8EZQN"
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
    "Blade_Atreus" = {
      datacenter-id = dependency.datacenter-config.outputs.dc_id
      hosts      = [
        "phst31.sof.intra",
        "phst32.sof.intra",
        "phst33.sof.intra",
        "phst34.sof.intra",
        "phst35.sof.intra",
        "phst36.sof.intra",
        "phst37.sof.intra",
        "phst38.sof.intra"
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
        enabled                       = false
        datastore-apd-recovery-action = "reset"
        datastore-apd-response        = "restartConservative"
        datastore-apd-response-delay  = 300
        datastore-pdl-response        = "restartAggressive"
        vm-maximum-failure-window     = 3600
        advanced-options = {
          "das.respectVmHostSoftAffinityRules" = "false"
          "das.respectVmVmAntiAffinityRules"   = "false"
        }
        }
      tags          = null
    }     
    "Blade_Kratos" = {
      datacenter-id = dependency.datacenter-config.outputs.dc_id
      hosts      = [
        "phst41.sof.intra",
        "phst42.sof.intra",
        "phst43.sof.intra",
        "phst44.sof.intra"
      ]
      drs           = {
        enabled          = true
        automation-level = "fullyAutomated"
      }
      dpm           = {
        enabled          = false
        automation-level = "automated"
      }
      ha            = {
        enabled                       = true
        datastore-apd-recovery-action = "reset"
        datastore-apd-response        = "restartConservative"
        datastore-apd-response-delay  = 300
        datastore-pdl-response        = "restartAggressive"
        vm-maximum-failure-window     = 3600
      }
      tags          = [
        "urn:vmomi:InventoryServiceTag:f00cd682-7d86-4542-b9bc-8035c46bdffa:GLOBAL"
      ]
    }
  }
  
  resource-pool = {
    "Desenv_Test"           = {
      compute-cluster          = "Blade_Atreus"
      cpu-share-level          = "low"
      memory-share-level       = "low"
      scale-descendants-shares = "disabled"
    }
    "DevOPS_Atreus_Staging" = {
      compute-cluster          = "Blade_Atreus"
      cpu-share-level          = "high"
      memory-share-level       = "high"
      scale-descendants-shares = "disabled"
    }
    "DevOps_Atreus_Teste"   = {
      compute-cluster          = "Blade_Atreus"
      cpu-share-level          = "low"
      memory-share-level       = "low"
      scale-descendants-shares = "disabled"
    }
    "SEAIN"                 = {
      compute-cluster          = "Blade_Atreus"
      scale-descendants-shares = "disabled"
    }
    "WINDOWS"               = {
      compute-cluster          = "Blade_Atreus"
      cpu-share-level          = "high"
      memory-share-level       = "high"
      scale-descendants-shares = "disabled"
    }
  }
}


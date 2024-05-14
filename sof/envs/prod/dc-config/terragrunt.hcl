include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../../modules/vsphere/datacenter-config"
}

inputs = {
  datacenter = {
    dc-name = "SOF"
    tags    = ["urn:vmomi:InventoryServiceTag:7cc018fa-7303-4ade-88f8-50047a7ba0ba:GLOBAL"] 
  }

  datastore-cluster = {
    "Storage_EMC_NL-SAS" = {
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
    "Storage_EMC_SAS" = {
      sdrs = {
        enabled                        = true
        automation-level               = "automated"
        free-space-utilization-diff    = 10
        io-balance-automation-level    = "manual"
        io-latency-threshold           = 15
        io-load-imbalance-threshold    = 20
        load-balance-interval          = 360
        space-balance-automation-level = "automated"
        space-utilization-threshold    = 80
      }
      tags = null
    }
    "Storage_IBM" = {
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

  compute-cluster = {
    "Blade_Atreus" = {
      host-ids = [
        "host-127476",
        "host-146094",
        "host-146230",
        "host-146271",
        "host-146274",
        "host-146318",
        "host-146467",
        "host-146571"
      ]
      drs  = {
        enabled          = true
        automation-level = "fullyAutomated"
        advanced-options = {
          "PercentIdleMBInMemDemand" = "100"
        } 
      }
      dpm = {
        enabled          = false
        automation-level = "automated"
      }
      ha   = {
        enabled                       = true
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
      tags = null
    }
    "Blade_Kratos" = {
      host-ids = [
        "host-126508",
        "host-146541",
        "host-146553",
        "host-146562"
      ]
      drs  = {
        enabled          = true
        automation-level = "fullyAutomated"
      }
      dpm = {
        enabled          = false
        automation-level = "automated"
      }
      ha   = {
        enabled                       = true
        datastore-apd-recovery-action = "reset"
        datastore-apd-response        = "restartConservative"
        datastore-apd-response-delay  = 300
        datastore-pdl-response        = "restartAggressive"
        vm-maximum-failure-window     = 3600
      }
      tags = [
        "urn:vmomi:InventoryServiceTag:f00cd682-7d86-4542-b9bc-8035c46bdffa:GLOBAL"
      ]
    }
    "Dell_R720_Com_Suporte" = {
      host-ids = [
        "host-146575",
        "host-146600"
      ]      
      drs  = {
        enabled          = false
        automation-level = "fullyAutomated"
      }
      dpm = {
        enabled          = false
        automation-level = "automated"
      }
      ha   = {
        enabled = false
        datastore-apd-response        = "restartConservative"
        datastore-pdl-response        = "restartAggressive"
      }
      tags = null
    }
    "Dell_R910_Com_Suporte" = {
      host-ids = [
        "host-146090",
        "host-146161",
        "host-146211",
        "host-146214",
        "host-146223",
        "host-66553"
      ]
      drs  = {
        enabled          = true
        automation-level = "fullyAutomated"
      }
      dpm = {
        enabled          = false
        automation-level = "automated"
      }
      ha   = {
        enabled = true
        datastore-apd-response        = "restartConservative"
        datastore-pdl-response        = "restartAggressive"
      }
      tags = null
    }
    "Dell_R910_Laboratorio" = {      
      folder   = "Equipamentos_sem_suporte_apenas_labs"
      host-ids = [
        "host-146101",
        "host-146155",
        "host-146164",
        "host-146185",
        "host-146202",
        "host-147537"
      ]      
      drs  = {
        enabled          = true
        automation-level = "fullyAutomated"
      }
      dpm = {
        enabled          = false
        automation-level = "automated"
      }
      ha   = {
        enabled                   = true
        datastore-apd-response    = "restartConservative"
        datastore-pdl-response    = "restartAggressive"
        vm-maximum-failure-window = 3600
        advanced-options          = {
          "das.ignoreRedundantNetWarning" = "true"
        }
      }
      tags = null
    }
  }
  
  resource-pool = {
    "Desenv_Test"           = {
      cluster-name = "Blade_Atreus"
    }
    "DevOPS_Atreus_Staging" = {
      cluster-name       = "Blade_Atreus"
      cpu-share-level    = "high"
      memory-share-level = "high"
    }
    "DevOps_Atreus_Teste"   = {
      cluster-name = "Blade_Atreus"
    }
    "SEAIN"                 = {
      cluster-name = "Blade_Atreus"
    }
    "WINDOWS"               = {
      cluster-name       = "Blade_Atreus"
      cpu-share-level    = "high"
      memory-share-level = "high"
    }
    "DevOps_Kratos_PRD"    = {
      cluster-name       = "Blade_Kratos"
      cpu-share-level    = "high"
      memory-share-level = "high"
    }
    "Infra_SOF"            = {
      cluster-name = "Blade_Kratos"
    }
    "Producao_SOF"            = {
      cluster-name = "Blade_Kratos"
    }
    "VMware_SOF"    = {
      cluster-name       = "Blade_Kratos"
      cpu-share-level    = "high"
      memory-share-level = "high"
    }
  }
}


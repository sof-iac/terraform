terraform {
  source = "../../../../modules/vsphere/network"
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
  vds = {
    "VDS_BLK" = {
      datacenter                        = dependency.datacenter-config.outputs.dc_id
      ignore-other-pvlan-mappings       = null
      netflow-sampling-rate             = 4096
      network-resource-control-enabled  = true
      tags                              = []
      hosts                             = [
        {
          host-id = dependency.host-resources.outputs.hosts["phst41.blocok.sof.remoto"].id
          devices = ["vmnic2", "vmnic3"]
        },
        {
          host-id = dependency.host-resources.outputs.hosts["phst42.blocok.sof.remoto"].id
          devices = ["vmnic2", "vmnic3"]
        },
        {
          host-id = dependency.host-resources.outputs.hosts["phst43.blocok.sof.remoto"].id
          devices = ["vmnic2"]
        },
        {
          host-id = dependency.host-resources.outputs.hosts["phst44.blocok.sof.remoto"].id
          devices = ["vmnic2", "vmnic3"]
        }
      ]
    }
  }

  pg = {
    "VDS_GERENCIA" = {
      vds                             = "VDS_BLK"
      vlan-id                         = 2440
      block-override-allowed          = true
      network-resource-pool-key       = null
      port-config-reset-at-disconnect = true
    }  
    "VDS_SERVICO" = {
      vds                             = "VDS_BLK"
      vlan-id                         = 2441
      block-override-allowed          = true
      network-resource-pool-key       = null
      port-config-reset-at-disconnect = true
    }   
    "VDS_DOMINIO_RECURSO" = {
      vds                             = "VDS_BLK"
      vlan-id                         = 2442
      block-override-allowed          = true
      network-resource-pool-key       = null
      port-config-reset-at-disconnect = true
    }
    "VDS_DMZ" = {
      vds                             = "VDS_BLK"
      vlan-id                         = 2443
      block-override-allowed          = true
      network-resource-pool-key       = null
      port-config-reset-at-disconnect = true
    } 
    "VDS_KUBERNETES" = {
      vds                             = "VDS_BLK"
      vlan-id                         = 2444
      block-override-allowed          = true
      network-resource-pool-key       = null
      port-config-reset-at-disconnect = true
    }
    "VDS_VMOTION" = {
      vds                             = "VDS_BLK"
      vlan-id                         = 2445
      block-override-allowed          = true
      network-resource-pool-key       = null
      port-config-reset-at-disconnect = true
    }  
  }
}
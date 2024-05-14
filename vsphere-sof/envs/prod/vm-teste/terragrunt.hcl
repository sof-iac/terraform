include {
  path = find_in_parent_folders()
}

dependency "dc-config" {
  config_path = "../dc-config"
}

terraform {
  source = "../../../../modules/vsphere/linux-vm"
}

inputs = {
  vm = {
    "testetf" = {
        template          = "templateoraclelinux84"
        instances         = 1
        datacenter        = "SOF" #dependency.dc-config.outputs.dc_id
        datastore-cluster = "Storage_IBM"
        resource-pool     = "DevOps_Atreus_Teste"
        network           = {"PG_Atlas_Teste" = ["192.168.30.156"]}
        mask              = ["24"]
        gateway           = "192.168.30.1"
        cpu               = 4
        memory            = 8192

    }  
  }
}


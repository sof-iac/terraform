include {
  path = find_in_parent_folders()
}

terraform {
  #source = "../../../../../modules/vsphere/linux_vm"
  source = "../../../../../modules/vmware_modules/vm/linux"  # Caminho relativo ao terragrunt.hcl
}

inputs = {
  vm = {
    "testetf" = {
        template          = "templateubuntu2204_ansible"
        instances         = 1
        datacenter        = "SOF" #dependency.dc-config.outputs.dc_id
        datastore-cluster = "Storage_Purestorage"
        resource-pool     = "Blade_Atreus/Resources"
        vsphere_cluster   = "Blade_Atreus"
        network           = {"PG_Atlas_Teste" = ["192.168.30.172"]}
        mask              = ["24"]
        gateway           = "192.168.30.1"
        cpu               = 2
        memory            = 8192
    }  
  },
  {
    "orcl01" = {
        template          = "templateoraclelinux810"
        instances         = 1
        datacenter        = "SOF" #dependency.dc-config.outputs.dc_id
        datastore-cluster = "Storage_Purestorage"
        resource-pool     = "Blade_Atreus/Resources"
        vsphere_cluster   = "Blade_Atreus"
        network           = {"PG_Atlas_Teste" = ["192.168.30.173"]}
        mask              = ["24"]
        gateway           = "192.168.30.1"
        cpu               = 2
        memory            = 8192
    }     
  }
}


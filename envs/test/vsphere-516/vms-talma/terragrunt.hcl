terraform {
  source = "../../../../modules/vsphere/vm/linux"  # Caminho relativo ao terragrunt.hcl
}

include {
  path = find_in_parent_folders()
}

locals {  
  vcenter        = basename(dirname(get_terragrunt_dir()))
  TF_VAR_VM_PASS = get_env("TF_VAR_VM_PASS")
  TF_VAR_DISTRO  = get_env("TF_VAR_DISTRO")
}  

inputs = {
  vm = {
    "ROBALMA" = {
      template          = "default-template-alma-9.6-base"
      staticvmname      = "ROBALMA"
      instances         = 1
      vmstartcount      = 0
      datacenter        = "SOF"
      datastore_cluster = "Purestorage_Default"
      resource_pool     = "Blade_Kratos/Resources"
      vsphere_cluster   = "Blade_Kratos"
      domain            = "sof.intra"
      network           = {"PG_Gaia_COINF_OPERACOES" = ["172.27.5.7"]}
      dns_server_list   = ["172.27.3.5", "172.27.3.6"]
      mask              = ["24"]
      gateway           = "172.27.5.1"
      cpu               = 8
      memory            = 16384
      local_adminpass   = "${local.TF_VAR_VM_PASS}"
      distro            = "${local.TF_VAR_DISTRO}"
      network_type      = ["vmxnet3"]
      annotation        = "TESTE ALMA ANSIBLE"
        tags = { }        
      # Adicionando discos adicionais  
      template_disk_io_reservation = [1,1,1] 
      data_disk                    = { }  
    }
  }       
}
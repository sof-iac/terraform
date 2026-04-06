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
    "TSZB" = {
      template            = "default-template-ubuntu2404-base"
      instances           = 1
      vmstartcount        = 1
      datacenter          = "SOF"
      datastore_cluster   = "Purestorage_Default"
      resource_pool       = "Blade_Kratos/Resources"
      vsphere_cluster     = "Blade_Kratos"
      domain              = "sof.intra"
      network             = {"PG_Gaia_Dominio_Recurso" = ["172.27.3.40"]}
      dns_server_list     = []
      mask                = ["24"]
      gateway             = "172.27.5.1"
      cpu                 = 8
      memory              = 16384
      local_adminpass     = "${local.TF_VAR_VM_PASS}"
      distro              = "${local.TF_VAR_DISTRO}"
      network_type        = ["vmxnet3"]
      annotation          = "Máquina para o zabbix 7"
      tags                = { }        
      # Adicionando discos adicionais  
      template_disk_io_reservation = [1,1,1]
      template_disk_sizes = [21, 100, 7]
      data_disk           = { }  
    } 
  }     
}
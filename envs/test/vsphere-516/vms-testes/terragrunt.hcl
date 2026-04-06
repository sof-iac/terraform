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
    "TALM" = {
      template          = "default-template-alma-9.6-base"
      staticvmname      = null
      instances         = 1
      vmstartcount      = 1
      datacenter        = "SOF"
      datastore_cluster = "Purestorage_Default"
      resource_pool     = "Blade_Kratos/Resources"
      vsphere_cluster   = "Blade_Kratos"
      domain            = "sof.intra"
      network           = {"PG_Gaia_Kubestag" = ["192.168.21.238"]}
      dns_server_list   = []
      mask              = ["24"]
      gateway           = "192.168.21.1"
      cpu               = 2
      memory            = 4096
      local_adminpass   = "${local.TF_VAR_VM_PASS}"
      distro            = "${local.TF_VAR_DISTRO}"
      network_type      = ["vmxnet3"]
      annotation        = "TESTE ALMA ANSIBLE - 26/01/2026 - Rogerio Vieira Silva"
        tags = {
          "Origem"      = "Terraform"
          "Ambiente"    = "Test"
          "Aplicacao"   = "Jenkins"
          "Responsavel" = "Rogerio Vieira Silva"
        }        
        # Adicionando discos adicionais  
        template_disk_io_reservation = [1,1,1]
        data_disk       = { }  
    }
  }       
}
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
    "PELK" = {
        template          = "default-template-ubuntu2404-base"
        instances         = 1
        vmstartcount      = 7
        staticvmname      = null
        datacenter        = "SOF" #dependency.dc-config.outputs.dc_id
        datastore_cluster = "Purestorage_Default"
        resource_pool     = "Blade_Kratos/Resources"
        vsphere_cluster   = "Blade_Kratos"
        domain            = "sof.intra"
        # network           = {"PG_Gaia_Teste" = ["192.168.30.237"]}
        network           = {"PG_Gaia_COINF_OPERACOES" = ["172.27.5.237"]}
        dns_server_list   = ["172.27.3.5", "172.27.3.6"]
        mask              = ["24"]
        #gateway           = "192.168.30.1"
        gateway           = "172.27.5.1"
        cpu               = 4
        memory            = 16768
        local_adminpass   = "${local.TF_VAR_VM_PASS}"
        distro            = "${local.TF_VAR_DISTRO}"
        network_type      = ["vmxnet3"]
        annotation        = "Cluste ELK - Augusto Cantanhede - 08/05/2026"
        tags = {
          "Origem"    = "Terraform"
          "Ambiente"  = "Test"
        }      
        # Adicionando discos extras  
        data_disk = {}
    }
  }     
}
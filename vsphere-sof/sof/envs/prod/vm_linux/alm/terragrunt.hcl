include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../../../../modules/vsphere/vm/linux"  # Caminho relativo ao terragrunt.hcl
}

locals {  
  TF_VAR_VM_PASS = get_env("TF_VAR_VM_PASS")
  TF_VAR_DISTRO  = get_env("TF_VAR_DISTRO")
}  

inputs = {
  vm = {    
    "PDEP" = {
        template          = "templateubuntu2204_ansible"
        instances         = 1
        vmstartcount      = 1       
        datacenter        = "SOF" #dependency.dc-config.outputs.dc_id
        datastore_cluster = "Storage_Purestorage"
        datastore         = "Storage_Purestorage"
        resource_pool     = "Blade_Kratos/Resources"
        vsphere_cluster   = "Blade_Kratos"
        domain            = "sof.intra"
        network           = {"PG_Gaia_Apl_Internas" = ["192.168.50.59"]}
        mask              = ["23"]
        gateway           = "192.168.50.1"
        domain            = "sof.intra"
        cpu               = 4
        memory            = 8192
        local_adminpass   = "${local.TF_VAR_VM_PASS}"
        distro            = "${local.TF_VAR_DISTRO}"        
        network_type      = ["vmxnet3"]
        annotation        = "Servidor que subsituira o Dedp01 - 27/11/2024 - Rogerio Vieira Silva"
        tags = {
          "Origem"    = "Terraform"
          "Ambiente"  = "Prod"
          "Aplicacao" = "Jazz"
          "Responsavel" = "Rogerio Vieira Silva"
        }
      } 
    }   
}


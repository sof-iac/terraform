include {
  path = find_in_parent_folders()
}

terraform {
  #source = "../../../../../modules/vsphere/linux_vm"
  source = "../../../../../../modules/vsphere/vm/linux"  # Caminho relativo ao terragrunt.hcl
}

locals {  
  TF_VAR_VM_PASS = get_env("TF_VAR_VM_PASS")
  TF_VAR_DISTRO  = get_env("TF_VAR_DISTRO")
}  

inputs = {
  vm = { 
    "orcl02" = {
        template          = "templateoraclelinux810"
        instances         = 1
        vmstartcount      = 1        
        datacenter        = "SOF" #dependency.dc-config.outputs.dc_id
        datastore_cluster = "Storage_Purestorage"
        datastore         = "Storage_Purestorage"
        resource_pool     = "Blade_Atreus/Resources"
        vsphere_cluster   = "Blade_Atreus"
        domain            = "sof.intra"
        local_adminpass   = "${local.TF_VAR_VM_PASS}"
        distro            = "${local.TF_VAR_DISTRO}" 
        network_type      = ["vmxnet3"]
        network           = {"PG_Atlas_Teste" = ["192.168.30.177"]}
        mask              = ["24"]
        gateway           = "192.168.30.1"
        cpu               = 2
        memory            = 8192
        data_disk         = {}
        annotation        = "Servidor de LAb - 09/09/2024 - Rogerio Vieira Silva"
        tags = {
          "Origem"    = "Terraform"
          "Ambiente"  = "Teste"
        }          
    }    
  }     
}


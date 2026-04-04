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
    "LWIL" = {
        template          = "default-template-alma-9.6-base"
        instances         = 1
        vmstartcount      = 1
        staticvmname      = null
        datacenter        = "SOF" #dependency.dc-config.outputs.dc_id
        datastore_cluster = "Purestorage_Default"
        resource_pool     = "Blade_Kratos/Resources"
        vsphere_cluster   = "Blade_Kratos"
        domain            = "sof.intra"
        network           = {"PG_Gaia_Teste" = ["192.168.30.113"]}
        dns_server_list   = []
        mask              = ["24"]
        gateway           = "192.168.30.1"
        cpu               = 2
        memory            = 8192
        local_adminpass   = "${local.TF_VAR_VM_PASS}"
        distro            = "${local.TF_VAR_DISTRO}"
        network_type      = ["vmxnet3"]
        annotation        = "Servidor de Testes Wildfly - 12/02/2026 - Rogerio Vieira"
        tags = {
          "Origem"    = "Terraform"
          "Ambiente"  = "Lab"
          "Aplicacao" = "Apache"
          "Responsavel" = "Rogerio Vieira Silva"
        }     
        # Adicionando discos adicionais  
        template_disk_io_reservation = [1, 1, 1]  
        data_disk = { }  
    }           
  } 
}


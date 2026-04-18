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
    "TWIL" = {
        template          = "default-template-alma-9.6-base"
        instances         = 1
        vmstartcount      = 4
        staticvmname      = TWIL04
        datacenter        = "SOF" #dependency.dc-config.outputs.dc_id
        datastore_cluster = "Purestorage_Default"
        resource_pool     = "Blade_Kratos/Resources"
        vsphere_cluster   = "Blade_Kratos"
        domain            = "sof.intra"
        network           = {"PG_Gaia_Teste" = ["192.168.30.116"]}
        dns_server_list   = []
        mask              = ["24"]
        gateway           = "192.168.30.1"
        cpu               = 4
        memory            = 13312
        local_adminpass   = "${local.TF_VAR_VM_PASS}"
        distro            = "${local.TF_VAR_DISTRO}"
        network_type      = ["vmxnet3"]
        annotation        = "Servidor de Testes Wildfly - 18/04/2026 - Rogerio Vieira"
        tags = {
          "Origem"    = "Terraform"
          "Ambiente"  = "Test"
          "Aplicacao" = "Wildfly"
          "Responsavel" = "Rogerio Vieira Silva"
        }     
        # Adicionando discos adicionais  
        template_disk_io_reservation = [1, 1, 1]  
        data_disk = { }  
    }           
  } 
}


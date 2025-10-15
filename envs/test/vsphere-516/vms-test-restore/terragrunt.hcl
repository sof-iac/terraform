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
    "RKBN" = {
        template          = "default-template-ubuntu-2404-k8s"
        instances         = 4
        vmstartcount      = 1
        staticvmname      = null
        datacenter        = "SOF" #dependency.dc-config.outputs.dc_id
        datastore_cluster = "Purestorage_Default"
        datastore         = "Purestorage_Default"
        resource_pool     = "Blade_Kratos/Resources"
        vsphere_cluster   = "Blade_Kratos"
        domain            = "sof.intra"
        network           = {"PG_Gaia_Servico_Kubernetes" = ["192.168.22.230","192.168.22.231","192.168.22.232","192.168.22.233"]}
        dns_server_list   = ["172.27.3.5", "172.27.3.6"]
        mask              = ["24"]
        gateway           = "192.168.22.1"
        cpu               = 4
        memory            = 8192
        local_adminpass   = "${local.TF_VAR_VM_PASS}"
        distro            = "${local.TF_VAR_DISTRO}"
        network_type      = ["vmxnet3"]
        annotation        = "Cluster k8s Test Restore - Responsável: João Francisco Neiva de Carvalho"
        tags = {
          "Origem"    = "Terraform"
          "Ambiente"  = "Lab"
          "Aplicacao" = "k8s_test_restore"
          "Responsavel" = "João Francisco Neiva de Carvalho"
        }      
        # Adicionando discos extras  
        data_disk = {}
    }
  }     
}
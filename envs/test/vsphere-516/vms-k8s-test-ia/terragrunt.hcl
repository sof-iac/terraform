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
    "TKBN17" = {
        template          = "template-ubuntu-24-k8s-cp"
        instances         = 5
        vmstartcount      = 1
        staticvmname      = null
        datacenter        = "SOF" #dependency.dc-config.outputs.dc_id
        datastore_cluster = "Purestorage_Default"
        vsphere_cluster   = "Blade_Kratos"
        resource_pool     = "Blade_Kratos/Resources"
        domain            = "sof.intra"
        network           = {"PG_Gaia_Kubestag" = ["192.168.21.171","192.168.21.172","192.168.21.173","192.168.21.174","192.168.21.175"]}
        dns_server_list   = ["172.27.3.5", "172.27.3.6"]
        mask              = ["24"]
        gateway           = "192.168.21.1"
        cpu               = 8
        memory            = 16384
        local_adminpass   = "${local.TF_VAR_VM_PASS}"
        distro            = "${local.TF_VAR_DISTRO}"
        network_type      = ["vmxnet3"]
        annotation        = "VM Control Plane do cluster test-ai"
        tags = {
          "Origem"    = "Terraform"
          "Ambiente"  = "Test"
          "Aplicacao" = "kubernetes"
          "Responsavel" = "Nelson Sattler"
        }     
        # Adicionando discos adicionais  
        data_disk = { }  
    }
    "TKBN18" = {
        template          = "template-ubuntu-24-k8s-worker"
        instances         = 6
        vmstartcount      = 1
        staticvmname      = null
        datacenter        = "SOF" #dependency.dc-config.outputs.dc_id
        datastore_cluster = "Purestorage_Default"
        vsphere_cluster   = "Blade_Kratos"
        resource_pool     = "Blade_Kratos/Resources"
        domain            = "sof.intra"
        network           = {"PG_Gaia_Kubestag" = ["192.168.21.181","192.168.21.182","192.168.21.183","192.168.21.184","192.168.21.185","192.168.21.186"]
                             "PG_Gaia_NVMe-o-TCP_Portworx_K8s" = ["192.168.130.181","192.168.130.182","192.168.130.183","192.168.130.184","192.168.130.185","192.168.130.186"]}
        network_if_order  = ["PG_Gaia_Kubestag", "PG_Gaia_NVMe-o-TCP_Portworx_K8s"]
        dns_server_list   = ["172.27.3.5", "172.27.3.6"]
        mask              = ["24","23"]
        gateway           = "192.168.21.1"
        cpu               = 8
        memory            = 16384
        local_adminpass   = "${local.TF_VAR_VM_PASS}"
        distro            = "${local.TF_VAR_DISTRO}"
        network_type      = ["vmxnet3","vmxnet3"]
        annotation        = "VM Worker do cluster test-ai"
        tags = {
          "Origem"    = "Terraform"
          "Ambiente"  = "Test"
          "Aplicacao" = "kubernetes"
          "Responsavel" = "Nelson Sattler"
        }     
        # Adicionando discos adicionais  
        data_disk = { }  
    }
     "TKBN19" = {
        template          = "template-ubuntu-24-k8s-cp"
        instances         = 2
        vmstartcount      = 1
        staticvmname      = null
        datacenter        = "SOF" #dependency.dc-config.outputs.dc_id
        datastore_cluster = "Purestorage_Default"
        vsphere_cluster   = "Blade_Kratos"
        resource_pool     = "Blade_Kratos/Resources"
        domain            = "sof.intra"
        network           = {"PG_Gaia_Kubestag" = ["192.168.21.191","192.168.21.192"]
                             "PG_Gaia_NVMe-o-TCP_Portworx_K8s" = ["192.168.130.191","192.168.130.192"]}
        network_if_order  = ["PG_Gaia_Kubestag", "PG_Gaia_NVMe-o-TCP_Portworx_K8s"]
        dns_server_list   = ["172.27.3.5", "172.27.3.6"]
        mask              = ["24", "23"]
        gateway           = "192.168.21.1"
        cpu               = 12
        memory            = 32768
        local_adminpass   = "${local.TF_VAR_VM_PASS}"
        distro            = "${local.TF_VAR_DISTRO}"
        network_type      = ["vmxnet3","vmxnet3"]
        annotation        = "VM Large Worker do cluster test-ai, para execução da LLM"
        tags = {
          "Origem"    = "Terraform"
          "Ambiente"  = "Test"
          "Aplicacao" = "kubernetes"
          "Responsavel" = "Nelson Sattler"
        }     
        # Adicionando discos adicionais  
        data_disk = { }  
    }        
  } 
}


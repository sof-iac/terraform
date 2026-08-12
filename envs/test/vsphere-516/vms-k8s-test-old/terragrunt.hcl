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
    "TKBN20" = {
        template          = "template-ubuntu-24-k8s-cp"
        instances         = 5
        vmstartcount      = 1
        staticvmname      = null
        datacenter        = "SOF" #dependency.dc-config.outputs.dc_id
        datastore_cluster = "Purestorage_Default"
        vmfolder          = "Kubernetes"
        vsphere_cluster   = "Blade_Kratos"
        resource_pool     = "Blade_Kratos/Resources"
        domain            = "sof.intra"
        network           = {"PG_Gaia_Kubestag" = ["192.168.21.201","192.168.21.202","192.168.21.203","192.168.21.204","192.168.21.205"]}
        dns_server_list   = ["172.27.3.5", "172.27.3.6"]
        mask              = ["24"]
        gateway           = "192.168.21.1"
        cpu               = 8
        memory            = 16384
        local_adminpass   = "${local.TF_VAR_VM_PASS}"
        distro            = "${local.TF_VAR_DISTRO}"
        network_type      = ["vmxnet3"]
        annotation        = "VM Control Plane do cluster test-old"
        tags = {
          "Origem"      = "Terraform"
          "Ambiente"    = "Test"
          "Aplicacao"   = "kubernetes"
          "Responsavel" = "Nelson Sattler"
        }     
        # Adicionando discos extras  
        data_disk = { }  
    }
    "TKBN2" = {
        template          = "template-ubuntu-24-k8s-worker"
        instances         = 10
        vmstartcount      = 11
        staticvmname      = null
        datacenter        = "SOF" #dependency.dc-config.outputs.dc_id
        datastore_cluster = "Purestorage_Default"
        vmfolder          = "Kubernetes"
        vsphere_cluster   = "Blade_Kratos"
        resource_pool     = "Blade_Kratos/Resources"
        domain            = "sof.intra"
        network           = {"PG_Gaia_Kubestag" = ["192.168.21.211","192.168.21.212","192.168.21.213","192.168.21.214","192.168.21.215","192.168.21.216","192.168.21.217","192.168.21.218","192.168.21.219","192.168.21.220"]
                             "PG_Gaia_NVMe-o-TCP_Portworx_K8s" = ["192.168.130.211","192.168.130.212","192.168.130.213","192.168.130.214","192.168.130.215","192.168.130.216","192.168.130.217","192.168.130.218","192.168.130.219","192.168.130.220"]}
        network_if_order  = ["PG_Gaia_Kubestag", "PG_Gaia_NVMe-o-TCP_Portworx_K8s"]
        dns_server_list   = ["172.27.3.5", "172.27.3.6"]
        mask              = ["24","23"]
        gateway           = "192.168.21.1"
        cpu               = 8
        memory            = 16384
        local_adminpass   = "${local.TF_VAR_VM_PASS}"
        distro            = "${local.TF_VAR_DISTRO}"
        network_type      = ["vmxnet3","vmxnet3"]
        annotation        = "VM Worker do cluster test-old"
        tags = {
          "Origem"      = "Terraform"
          "Ambiente"    = "Test"
          "Aplicacao"   = "kubernetes"
          "Responsavel" = "Nelson Sattler"
        }     
        # Adicionando discos extras  
        data_disk = { }  
    }
  } 
}


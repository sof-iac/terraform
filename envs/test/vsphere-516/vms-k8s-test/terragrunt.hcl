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
    "tkbn10" = {
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
        network           = {"PG_Gaia_Kubestag" = ["192.168.21.101","192.168.21.102","192.168.21.103","192.168.21.104","192.168.21.105"]}
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
    "tkbn2" = {
        template          = "template-ubuntu-24-k8s-worker"
        instances         = 12
        vmstartcount      = 11
        staticvmname      = null
        datacenter        = "SOF" #dependency.dc-config.outputs.dc_id
        datastore_cluster = "Purestorage_Default"
        vmfolder          = "Kubernetes"
        vsphere_cluster   = "Blade_Kratos"
        resource_pool     = "Blade_Kratos/Resources"
        domain            = "sof.intra"
        network           = {"PG_Gaia_Kubestag" = ["192.168.21.111","192.168.21.112","192.168.21.113","192.168.21.114","192.168.21.115","192.168.21.116","192.168.21.117","192.168.21.118","192.168.21.119","192.168.21.120","192.168.21.121","192.168.21.122"]
                             "PG_Gaia_NVMe-o-TCP_Portworx_K8s" = ["192.168.130.111","192.168.130.112","192.168.130.113","192.168.130.114","192.168.130.115","192.168.130.116","192.168.130.117","192.168.130.118","192.168.130.119","192.168.130.120","192.168.130.121","192.168.130.122"]}
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


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
    "TKBN" = {
        template          = "default-template-ubuntu-2404-k8s"
        instances         = 6
        vmstartcount      = 1
        staticvmname      = null
        datacenter        = "SOF" #dependency.dc-config.outputs.dc_id
        datastore_cluster = "Purestorage_Default"
        datastore         = "Purestorage_Default"
        resource_pool     = "Blade_Kratos/Resources"
        vsphere_cluster   = "Blade_Kratos"
        domain            = "sof.intra"
        network           = {"PG_Gaia_Servico_Kubernets" = ["192.168.22.201","192.168.22.202","192.168.22.203","192.168.22.204","192.168.22.205","192.168.22.206"]}
        dns_server_list   = ["172.27.3.5", "172.27.3.6"]
        mask              = ["24"]
        gateway           = "192.168.22.1"
        cpu               = 4
        memory            = 8192
        local_adminpass   = "${local.TF_VAR_VM_PASS}"
        distro            = "${local.TF_VAR_DISTRO}"
        network_type      = ["vmxnet3"]
        annotation        = "Cluster testes - Portworx - Rogerio Vieira Silva"
        tags = { }        
        # Adicionando discos adicionais  
        data_disk = {
          "disk_A1" = {
            size_gb                = 35
            unit_number            = 3
            thin_provisioned       = true
            eagerly_scrub          = false
            storage_policy_id      = null
            io_reservation         = null
            io_share_level         = "normal"
            disk_mode              = null
            disk_sharing           = null
            attach                 = null
            path                   = null
        }
      }
    }
  }     
}
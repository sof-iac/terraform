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
    "TELK" = {
        template          = "default-template-ubuntu2404-base"
        instances         = 3
        vmstartcount      = 30
        staticvmname      = null
        datacenter        = "SOF" #dependency.dc-config.outputs.dc_id
        datastore_cluster = "Purestorage_Default"
        resource_pool     = "Blade_Kratos/Resources"
        vsphere_cluster   = "Blade_Kratos"
        domain            = "sof.intra"
        network           = {"PG_Gaia_Teste" = ["192.168.30.237", "192.168.30.238", "192.168.30.239"]}
        dns_server_list   = ["172.27.3.5", "172.27.3.6"]
        mask              = ["24"]
        gateway           = "192.168.30.1"
        cpu               = 2
        memory            = 16768
        local_adminpass   = "${local.TF_VAR_VM_PASS}"
        distro            = "${local.TF_VAR_DISTRO}"
        network_type      = ["vmxnet3"]
        annotation        = "Cluste ELK - Augusto Cantanhede - 08/05/2026"
        tags = {
          "Origem"    = "Terraform"
          "Ambiente"  = "Test"
        }

        # Adicionando discos adicionais
      template_disk_sizes = [21, 100, 7] 
      template_disk_io_reservation = [0, 1, 0]
      data_disk = {}
      }
    }
  }
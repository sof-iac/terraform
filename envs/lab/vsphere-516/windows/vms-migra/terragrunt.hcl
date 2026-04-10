terraform {
  source = "../../../../modules/vsphere/vm/windows"  # Caminho relativo ao terragrunt.hcl
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
    "LGAT" = {
        # Obrigatório: o módulo Windows usa each.value.vmname (não só a chave do mapa).
        vmname            = "LGAT"
        template          = "templateserver2022"
        instances         = 1
        vmstartcount      = 1
        datacenter        = "SOF"
        datastore_cluster = "Purestorage_Default"
        resource_pool     = "Blade_Kratos/Resources"
        vsphere_cluster   = "Blade_Kratos"
        domain            = "sof.intra"
        network           = { "PG_Gaia_Teste" = ["192.168.30.115"] }
        dns_server_list   = ["172.27.3.5", "172.27.3.6"]
        mask              = ["24"]
        gateway           = "192.168.30.1"
        cpu               = 2
        memory            = 8192
        local_adminpass   = "${local.TF_VAR_VM_PASS}"
        distro            = "${local.TF_VAR_DISTRO}"
        network_type      = ["vmxnet3"]
        annotation        = "Servidor de Testes windows - 10/04/2026 - Rogerio Vieira"
        tags = {
          "Origem"      = "Terraform"
          "Ambiente"    = "Lab"
          "Responsavel" = "Rogerio Vieira Silva"
        }
        data_disk = {}
        # Disco / SCSI (contrato do módulo — repassados ao terraform_vsphere_vm)
        scsi_bus_sharing  = "noSharing"
        scsi_type         = "pvscsi"
        scsi_controller   = 0
        enable_disk_uuid  = true
        # Customização Windows (workgroup; use orgname conforme sysprep)
        orgname           = "SOF"
        workgroup         = "WORKGROUP"
        is_windows_image  = true
        firmware          = "efi"
    }
  }
}


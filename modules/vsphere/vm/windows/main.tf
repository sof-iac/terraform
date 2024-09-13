module "vsphere_windows_vm" {

  source    = "./terraform_vsphere_vm"

  for_each = var.vm
  # Parametros da VM
  dc                = each.value.datacenter
  datastore_cluster = each.value.datastore_cluster
  vmrp              = each.value.resource_pool
  vmname            = each.value.vmname
  vmtemp            = each.value.template
  instances         = each.value.instances 
  vmstartcount  = each.value.vmstartcount
  cpu_number        = each.value.cpu
  ram_size          = each.value.memory
  local_adminpass   = each.value.local_adminpass 
  # Parametros de rede
  network           = each.value.network
  domain            = each.value.domain
  dns_server_list   = each.value.dns_server_list
  ipv4submask       = each.value.mask
  vmgateway         = each.value.gateway 
  network_type      = each.value.network_type
  
  #template_storage_policy_id = each.value.template_storage_policy_id
  annotation     = each.value.annotation
  tags           = each.value.tags
  # Parametros de disco
  data_disk        = each.value.data_disk 
  scsi_bus_sharing = each.value.scsi_bus_sharing
  scsi_type        = each.value.scsi_type       
  scsi_controller  = each.value.scsi_controller 
  enable_disk_uuid = each.value.enable_disk_uuid 
  # Parametros da Organizacao
  orgname          = each.value.orgname         
  workgroup        = each.value.workgroup       
  is_windows_image = each.value.is_windows_image

  firmware         = each.value.firmware  
  io_share_level = ["normal", "normal", "normal", "normal", "normal"] #essa linha precisa ser mantida por conta de um bug no módulo
}
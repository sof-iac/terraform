module "vsphere_linux_vm" {

  #source = "./vm_mod"
  source    = "./terraform_vsphere_vm"

  for_each = var.vm

  vmname        = each.key
  vmtemp        = each.value.template
  instances     = each.value.instances
  vmstartcount  = each.value.vmstartcount
  distro        = each.value.distro
  dc                = each.value.datacenter
  datastore_cluster = each.value.datastore_cluster
  vmrp              = each.value.resource_pool
  local_adminpass   = each.value.local_adminpass
  
  network     = each.value.network
  domain      = each.value.domain
  ipv4submask = each.value.mask
  vmgateway   = each.value.gateway 
  network_type   = each.value.network_type
  annotation     = each.value.annotation
  data_disk      = each.value.data_disk 
  tags           = each.value.tags
  io_share_level = ["normal", "normal", "normal", "normal", "normal"] #essa linha precisa ser mantida por conta de um bug no módulo
  cpu_number     = each.value.cpu
  ram_size       = each.value.memory
}
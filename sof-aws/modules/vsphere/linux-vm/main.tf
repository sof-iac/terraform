module "vsphere-linux-vm" {
  source    = "Terraform-VMWare-Modules/vm/vsphere"

  for_each = var.vm

  vmname    = each.key
  vmtemp    = each.value.template
  instances = each.value.instances
  
  dc                = each.value.datacenter
  datastore_cluster = each.value.datastore-cluster
  vmrp              = each.value.resource-pool
  
  network     = each.value.network
  ipv4submask = each.value.mask
  vmgateway   = each.value.gateway 
  
  # data_disk  = each.value.data-disk
  io_share_level = ["normal", "normal", "normal", "normal", "normal"] #essa linha precisa ser mantida por conta de um bug no módulo
  cpu_number     = each.value.cpu
  ram_size       = each.value.memory
}
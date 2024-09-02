module "vsphere_linux_vm" {

  source = "./vm_mod"
  #source    = "Terraform-VMWare-Modules/vm/vsphere"

  for_each = var.vm

  vmname    = each.key
  #vmtemp    = each.value.template
  instances = each.value.instances
  template  = each.value.template
  vsphere_cluster = each.value.vsphere_cluster
  
  #dc                = each.value.datacenter
  datacenter        = each.value.datacenter
  datastore_cluster = each.value.datastore_cluster
  datastore         = each.value.datastore
  #vmrp              = each.value.resource_pool
  resource_pool     = each.value.resource_pool
  
  network     = each.value.network
  #ipv4submask = each.value.mask
  mask        = each.value.mask
  #vmgateway   = each.value.gateway 
  gateway     = each.value.gateway
  disk_size   = each.value.disk_size
  
  # data_disk  = each.value.data-disk
  io_share_level = ["normal", "normal", "normal", "normal", "normal"] #essa linha precisa ser mantida por conta de um bug no módulo
  cpu_number     = each.value.cpu
  ram_size       = each.value.memory
}
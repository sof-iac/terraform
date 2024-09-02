resource "vsphere_virtual_machine" "vm" {  
  name             = var.vmname  
  resource_pool_id = var.resource_pool  
  datastore_id     = var.datastore  

  num_cpus = var.cpu_number  
  memory   = var.ram_size  

  network_interface {  
    network_id   = var.network  
    adapter_type = "vmxnet3"  
  }  

  disk {  
    label            = "disk0"  
    size             = var.disk_size  
    eagerly_scrub    = false  
    thin_provisioned = true  
  }  
}
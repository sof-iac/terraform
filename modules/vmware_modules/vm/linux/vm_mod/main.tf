resource "vsphere_virtual_machine" "vm" {  
  name             = var.vmname  
  resource_pool_id = var.resource_pool  
  datastore_id     = var.datastore  

  num_cpus = var.cpu_number  
  memory   = var.ram_size  

  network_interface {  
    network_id   = var.network  
    adapter_type = "vmxnet3"  
    ipv4_address = var.ip_address     # Endereço IP estático  
    ipv4_netmask = var.mask[0]        # Máscara de sub-rede (supondo que seja uma lista)    
  }  

  disk {  
    label            = "disk0"  
    size             = var.disk_size  
    eagerly_scrub    = false  
    thin_provisioned = true  
  }  
}
data "vsphere_datacenter" "dc" {  
  name = var.vm["testetf"].datacenter  
}  

data "vsphere_datastore_cluster" "datastore_cluster" {  
  name          = var.vm["testetf"].datastore_cluster  
  datacenter_id = data.vsphere_datacenter.dc.id  
}  

data "vsphere_compute_cluster" "cluster" {  
  name          = var.vm["testetf"].vsphere_cluster  
  datacenter_id = data.vsphere_datacenter.dc.id  
}  

data "vsphere_network" "network" {  
  name          = keys(var.vm["testetf"].network)[0]  
  datacenter_id = data.vsphere_datacenter.dc.id  
}  

data "vsphere_virtual_machine" "template" {  
  name          = var.vm["testetf"].template  
  datacenter_id = data.vsphere_datacenter.dc.id  
}  

resource "vsphere_virtual_machine" "vm" {  
  count               = var.vm["testetf"].instances  
  name                = "testetf-${count.index}"  
  resource_pool_id    = data.vsphere_compute_cluster.cluster.resource_pool_id  
  datastore_id        = data.vsphere_datastore_cluster.datastore_cluster.datastore_ids[0]  
  num_cpus           = var.vm["testetf"].cpu  
  memory             = var.vm["testetf"].memory  
  guest_id           = data.vsphere_virtual_machine.template.guest_id  

  network_interface {  
    network_id   = data.vsphere_network.network.id  
    adapter_type = data.vsphere_virtual_machine.template.network_interface_types[0]  
    
    ipv4_address = var.vm["testetf"].network["PG_Atlas_Teste"][0]  
    ipv4_netmask = tonumber(var.vm["testetf"].mask[0])  
  }  

  disk {  
    label            = "disk0"  
    size             = data.vsphere_virtual_machine.template.disks.0.size  
    eagerly_scrub    = false  
    thin_provisioned = true  
  }  

  clone {  
    template_uuid = data.vsphere_virtual_machine.template.id  

    customize {  
      linux_options {  
        host_name = "testetf"  
        domain  = "local"  
      }  

      network_interface {  
        ipv4_address = var.vm["testetf"].network["PG_Atlas_Teste"][0]  
        ipv4_netmask = tonumber(var.vm["testetf"].mask[0])  
      }  

      ipv4_gateway = var.vm["testetf"].gateway  
    }  
  }  
}
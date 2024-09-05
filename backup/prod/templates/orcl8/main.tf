resource "null_resource" "download_iso" {  
  provisioner "local-exec" {  
    command = <<EOT  
      curl -L -o "oracle_linux_8.iso" "https://download.oracle.com/otn/linux/ol8/8.6/OracleLinux-R8-U6-x86_64-dvd.iso"  
    EOT  
  }  
} 

data "vsphere_datacenter" "dc" {  
  name = "SOF"  
}  

data "vsphere_datastore" "datastore" {  
  name          = "Storage_Purestorage"
  datacenter_id = data.vsphere_datacenter.dc.id
}  

data "vsphere_resource_pool" "pool" {
  name          = "Blade_Atreus/Resources"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network" {  
  name          = "PG_Atlas_Teste"  
  datacenter_id = data.vsphere_datacenter.dc.id  
}  
 

resource "vsphere_virtual_machine" "vm" {  
  depends_on = [null_resource.download_iso]  

  name             = "Oracle8_VM"  
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id  
  datastore_id     = data.vsphere_datastore.datastore.id  

  num_cpus = 2  
  memory   = 4096  
  guest_id = "oracle8_64Guest"  # Defina o guest_id apropriado para Oracle Linux  

  network_interface {  
    network_id   = data.vsphere_network.network.id  
    adapter_type = "vmxnet3"  # Tipo de adaptador de rede  
  }  

  disk {  
    label            = "disk0"  
    size             = 20  # Tamanho do disco em GB  
    eagerly_scrub    = false  
    thin_provisioned = true  
  }  

  cdrom {  
    label = "CD/DVD Drive 1"  
    connected = true  
    start_connected = true  
    datastore_id = data.vsphere_datastore.datastore.id  
    iso_path = "[${data.vsphere_datastore.datastore.name}] oracle_linux_8.iso"  # Caminho para a imagem ISO  
  }  

  clone {  
    # Se você tiver um template existente, caso contrário, remova esta seção  
    template_uuid = data.vsphere_virtual_machine.template.id  

    customize {  
      linux_options {  
        host_name = "Oracle8_VM"  
        domain  = "local"  
      }  

      network_interface {  
        ipv4_address = "192.168.30.238"  
        ipv4_netmask = 24  
      }  

      ipv4_gateway = "192.168.30.1"  
    }  
  }  
}  


resource "vsphere_virtual_machine" "new_template" {  
  name             = "Oracle8-New-Template"  
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id  
  datastore_id     = data.vsphere_datastore.datastore.id  

  num_cpus = 2  
  memory   = 4096  
  guest_id = data.vsphere_virtual_machine.template.guest_id  
  
  lifecycle {  
    ignore_changes = [network_interface]  
  }  

  network_interface {  
    network_id   = data.vsphere_network.network.id  
    adapter_type = data.vsphere_virtual_machine.template.network_interface_types[0]  
  }  

  disk {  
    label            = "disk0"  
    size             = data.vsphere_virtual_machine.template.disks.0.size  
    eagerly_scrub    = false  
    thin_provisioned = true  
  }  

  provisioner "local-exec" {  
    command = "govc vm.mark -template ${self.id}" # Comando para transformar a VM em template  
  }  

  clone {  
    template_uuid = data.vsphere_virtual_machine.template.id  
  }  
}
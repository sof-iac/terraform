# sof/envs/lab/test_connection.tf
# modules/Ubuntu_Cloud/main.tf

locals {
  templatevars = {
    name         = var.name,
    host_name    = var.host_name,
  }
}

data "vsphere_datacenter" "dc" {
  name = "SOF"
}
data "vsphere_datastore_cluster" "datastore_cluster" {
  name          = "Storage_Purestorage"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_resource_pool" "pool" {
  name          = "Blade_Atreus/Resources" 
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}


#data "vsphere_datastore" "datastore" {
  #name          = var.vsphere_datastore
  #datacenter_id = data.vsphere_datacenter.dc.id
#}

#data "vsphere_compute_cluster" "cluster" {
  #name          = var.vsphere_cluster
  #datacenter_id = data.vsphere_datacenter.dc.id
#}

data "vsphere_network" "network" {
  name          = var.vsphere_network
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_virtual_machine" "template" {
  name          = var.template
  datacenter_id = data.vsphere_datacenter.dc.id
}

resource "vsphere_virtual_machine" "vm" {
  count             = var.vm_count
  name              = upper(format("%s%02d", var.name_prefix, count.index + 1))
  resource_pool_id = "${data.vsphere_resource_pool.pool.id}"
  datastore_cluster_id     = "${data.vsphere_datastore_cluster.datastore_cluster.id}"
  #resource_pool_id  = data.vsphere_compute_cluster.cluster.id
 # datastore_id      = data.vsphere_datastore.datastore.id

  num_cpus          = var.cpus
  memory            = var.memory
  guest_id          = data.vsphere_virtual_machine.template.guest_id

  scsi_type = data.vsphere_virtual_machine.template.scsi_type

  network_interface {
    network_id       = data.vsphere_network.network.id
    adapter_type     = data.vsphere_virtual_machine.template.network_interface_types[0]
  }

  dynamic "disk" {
    for_each = "${data.vsphere_virtual_machine.template.disks}"
      content {
        label = "${disk.value["label"]}"
        size = disk.value["size"]
        unit_number = disk.value["unit_number"]
        thin_provisioned  = disk.value["thin_provisioned"]
    }
  }

  cdrom {
    client_device = true
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template.id

    customize {
      linux_options {
        host_name = var.host_name
        domain    = var.domain
      }

      network_interface {
        ipv4_address = var.ipv4_addres
        ipv4_netmask = var.ipv4_netmask
      }

      ipv4_gateway    = var.ipv4_gateway
      dns_server_list = [var.dns_server_list]
    }
  }
}


output "datacenter_id" {
  value = data.vsphere_datacenter.dc.id
}

variable "vm_name" {
  type        = string
  description = "VM Name"
  default = "ubuntu_teste"
}

provider "vsphere" {

  # If you have a self-signed cert
  allow_unverified_ssl = true
}

data "vsphere_datacenter" "dc" {
  name = "SOF"
}

data "vsphere_datastore_cluster" "datastore_cluster" {
  name          = "Storage_IBM"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_resource_pool" "pool" {
  name          = "DevOps_Atreus_Teste"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_network" "network" {
  name          = "PG_Atlas_Servico_Kubernets"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_virtual_machine" "template" {
  name          = "Template_Ubuntu_2204_Server_LTS"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

resource "vsphere_virtual_machine" "vm" {
  name             = var.vm_name
  resource_pool_id = "${data.vsphere_resource_pool.pool.id}"
  datastore_cluster_id     = "${data.vsphere_datastore_cluster.datastore_cluster.id}"

  num_cpus = 1
  memory   = 1024
  guest_id = "${data.vsphere_virtual_machine.template.guest_id}"

  network_interface {
    network_id = "${data.vsphere_network.network.id}"
    ipv4_address = "192.168.30.252"
    ipv4_netmask = "255.255.255.0"
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
#  disk {
#    label            = "disk0"
#    size             = 10
#    thin_provisioned = false
#  }

  clone {
    template_uuid = "${data.vsphere_virtual_machine.template.id}"
  }

  wait_for_guest_net_timeout    = -1
}







# Build New VM
#data "vsphere_datacenter" "SOF" {
#  name = "SOF"
#}
#data "vsphere_datastore" "Storage_IBM" {
#  name          = Storage_IBM
#  datacenter_id = data.vsphere_datacenter.datacenter.id
#}
#data "vra_cloud_account_vsphere" "pvcn01.sof.intra/SOF-1" {
#name = pvcn01.sof.intra/SOF-1.vra_cloud_account_vsphere_name
#}
#data "vsphere_resource_pool" "DevOps_Atreus_Teste" {}
#data "vsphere_network" "PG_Atlas_Servico_Kubernets" {
#  name          = PG_Atlas_Servico_Kubernets.mgmt_lan
#  datacenter_id = data.vsphere_datacenter.datacenter.id
#}
#resource "vsphere_virtual_machine" "TESTE-TF" {
#  count                      = 1
#  name                       = TESTE-TF
#  resource_pool_id           = data.vsphere_resource_pool.pool.id
#  datastore_id               = data.vsphere_datastore.datastore.id
#  force_power_off            = true
#  shutdown_wait_timeout      = 1
#  num_cpus                   = 1
#  memory                     = 2048
#  wait_for_guest_net_timeout = 0
#  nested_hv_enabled          = true
  
  #network_interface {
  #  network_id   = data.vsphere_network.networking.id
  #  adapter_type = vmxnet3
  #}
  
#data "vsphere_virtual_machine" "Template_Ubuntu_2204_Server_LTS" {
#  name          = "Template_Ubuntu_2204_Server_LTS"
#  datacenter_id = data.vsphere_datacenter.datacenter.id
#}
#}
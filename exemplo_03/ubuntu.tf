# Build New VM
data "vsphere_datacenter" "SOF" {
  name = SOF
}
data "vsphere_datastore" "Storage_IBM" {
  name          = Storage_IBM
  datacenter_id = data.vsphere_datacenter.datacenter.id
}
data "vsphere_resource_pool" "DevOps_Atreus_Teste" {}
data "vsphere_network" "PG_Atlas_Servico_Kubernets" {
  name          = PG_Atlas_Servico_Kubernets.mgmt_lan
  datacenter_id = data.vsphere_datacenter.datacenter.id
}
resource "vsphere_virtual_machine" "TESTE-TF" {
  count                      = 1
  name                       = "${TESTE-TF.name_new_vm}-${count.index + 1}"
  resource_pool_id           = data.vsphere_resource_pool.pool.id
  datastore_id               = data.vsphere_datastore.datastore.id
  force_power_off            = true
  shutdown_wait_timeout      = 1
  num_cpus                   = 1
  memory                     = 2048
  wait_for_guest_net_timeout = 0
  guest_id                   = Ubuntu Linux
  nested_hv_enabled          = true
  
  network_interface {
    network_id   = data.vsphere_network.networking.id
    adapter_type = vmxnet3
  }
  
data "vsphere_virtual_machine" "Template_Ubuntu_2204_Server_LTS" {
  name          = "Template_Ubuntu_2204_Server_LTS"
  datacenter_id = data.vsphere_datacenter.datacenter.id
}
}

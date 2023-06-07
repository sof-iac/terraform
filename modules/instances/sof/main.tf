provider "vsphere" {
  user           = "seu-usuario"
  password       = "sua-senha"
  vsphere_server = "seu-servidor-vsphere"
}

resource "vsphere_virtual_machine" "example_vm" {
  name             = "exemplo-vm"
  resource_pool_id = "resource-pool-id"
  datastore_id     = "datastore-id"
  num_cpus         = 2
  memory           = 4096

  network_interface {
    network_id   = vsphere_network.example_network.id
    adapter_type = "vmxnet3"
  }
}

resource "vsphere_network" "example_network" {
  name        = "Cloud_vSphere_Network_1"
  vlan_id     = 10
  subnet_mask = "255.255.255.0"
}

resource "vsphere_distributed_virtual_switch" "example_dvs" {
  name = "exemplo-dvs"
}

resource "vsphere_distributed_port_group" "example_port_group" {
  name                  = "exemplo-port-group"
  distributed_switch_id = vsphere_distributed_virtual_switch.example_dvs.id
}

resource "vsphere_virtual_machine" "example_autoscale_vm" {
  name             = "exemplo-autoscale-vm"
  resource_pool_id = "resource-pool-id"
  datastore_id     = "datastore-id"
  num_cpus         = 1
  memory           = 1024

  network_interface {
    network_id   = vsphere_network.example_network.id
    adapter_type = "vmxnet3"
  }

  provisioner "remote-exec" {
    inline = [
      "echo 'Executando script de provisionamento...' > /tmp/provisioning.log",
    ]
  }
}

resource "vsphere_virtual_machine_autoscaling_policy" "example_autoscaling_policy" {
  name        = "exemplo-politica-autoscale"
  policy      = "metric"
  max_instances = 1
  min_instances = 1

  network_configuration {
    network_id   = vsphere_network.example_network.id
    assignment   = "static"
    address      = "192.168.30.252"
  }
}

# sof/envs/lab/test_connection.tf

data "vsphere_datacenter" "dc" {
  name = "Nome do seu datacenter"
}

output "datacenter_id" {
  value = data.vsphere_datacenter.dc.id
}

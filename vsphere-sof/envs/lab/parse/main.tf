# sof/envs/lab/test_connection.tf

data "vsphere_datacenter" "dc" {
  name  = var.datacenter
}

output "datacenter_id" {
  value = data.vsphere_datacenter.dc.id
}

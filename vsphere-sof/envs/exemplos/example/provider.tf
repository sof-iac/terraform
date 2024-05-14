# provider.tf

## Vcenter Vars ##
variable "vsphere_server" {}
variable "vsphere_user" {}
variable "vsphere_password" {}
variable "datacenter" {}
variable "cluster" {}
variable "datastore" {}

## VM Vars ##
variable "vm_pass" {}
variable "vm_user" {}
variable "ssh_key" {}

## Provider Init ##
provider "vsphere" {
  vsphere_server = var.vsphere_server
  user           = var.vsphere_user
  password       = var.vsphere_password

  allow_unverified_ssl = true
}

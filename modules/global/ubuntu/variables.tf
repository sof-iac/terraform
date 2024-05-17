variable "name" {
  type        = string
  description = "The name of the vSphere virtual machines and the hostname of the machine"
  default = "prep03"
}
variable "vm-domain" {
  type        = string
  description = "Linux virtual machine domain name for the machine. This, along with host_name, make up the FQDN of the virtual machine"
  default     = "sof.intra"
}

variable "vsphere-datacenter" {
  type        = string
  description = "Datacenter"
  default     = "SOF"
}

variable "vsphere_network" {
  type        = string
  description = "vsphere_network"
  default     = "PG_Atlas_Teste"
}

variable "vsphere_resource_pool" {
  type        = string
  description = "vsphere_resource_pool"
  default     = "Blade_Atreus/Resources"
}

variable "vm-guest-id" {
  type        = string
  description = "Guest Id do SO em uso"
  default     = "ubuntu64Guest"
}

variable "host_name" {
  type = string
  default = "ubuntu01tf"
}

variable "dns_server_list" {
  type = list(string)
  description = "List of DNS servers"
  default = ["172.27.3.5", "172.27.3.6"]
}

variable "ipv4_address" {
  type = string
  description = "ipv4 addresses for a vm"
  default = "192.168.30.234"
}

variable "ipv4_gateway" {
  type = string
  default = "192.168.30.1"
}

variable "ipv4_netmask" {
  type = string
  default = "24"
}

variable "ssh_username" {
  type      = string
  sensitive = true
  default   = "root"
}
variable "ssh_password" {
  type      = string
  sensitive = true
  default   = "sof123"
}
variable "svc_username" {
  type      = string
  sensitive = true
  default   = "ansible"
}
variable "svc_password" {
  type      = string
  sensitive = true
  default   = "ansible"
}

variable "privatekeypath" {
  type    = string
  default = "./id_ed25519"
}

variable "public_key" {
  type        = string
  description = "Public key to be used to ssh into a machine"
  default     = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJvaUICPun0zJo21vhsvaZpYegvpzZjxxkMQxPOF5xeL user_svc_puppet.sof.intra"
}

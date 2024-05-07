#====================#
# vCenter connection #
#====================#

variable "vsphere_unverified_ssl" {
  description = "Is the vCenter using a self signed certificate (true/false)"
  default     = "true"
}

variable "vsphere_datacenter" {
  description = "vSphere datacenter"
  default     = "SOF"
}

variable "vsphere_cluster" {
  description = "vSphere cluster"
  default     = "SOF"
}

#=========================#
# vSphere virtual machine #
#=========================#

variable "vm_datastore" {
  description = "Datastore used for the vSphere virtual machines"
  default     = "Storage_Purestorage"
}

variable "vm_network" {
  description = "Network used for the vSphere virtual machines"
  default     = "PG_Atlas_Teste"
}

variable "vm_template" {
  description = "Template used to create the vSphere virtual machines"
  default     = "CentOS 7.8 - Docker Template"
}

variable "vm_linked_clone" {
  description = "Use linked clone to create the vSphere virtual machine from the template (true/false). If you would like to use the linked clone feature, your template need to have one and only one snapshot"
  default = "false"
}

variable "vm_ip" {
  description = "Ip used for the vSpgere virtual machine"
  default     = "192.168.30.155"
}

variable "vm_netmask" {
  description = "Netmask used for the vSphere virtual machine (example: 24)"
  default     = "24"
}

variable "vm_gateway" {
  description = "Gateway for the vSphere virtual machine"
  default     = "192.168.30.1"
}

variable "vm_dns" {
  description = "DNS for the vSphere virtual machine"
  default     = ["172.27.3.5", "172.27.3.6"]
}

variable "vm_domain" {
  description = "Domain for the vSphere virtual machine"
  default     = "sof.intra"
}

variable "vm_cpu" {
  description = "Number of vCPU for the vSphere virtual machines"
  default     = "1"
}

variable "vm_ram" {
  description = "Amount of RAM for the vSphere virtual machines (example: 2048)"
  default     = "4096"
}

variable "vm_name" {
  description = "The name of the vSphere virtual machines and the hostname of the machine"
  default     = "centos01tf"
}

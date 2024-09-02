variable "datacenter" {  
  description = "The datacenter where the VM should be deployed"  
  type        = string  
}  

variable "datastore_cluster" {  
  description = "The datastore cluster where the VM will be stored"  
  type        = string  
} 

variable "datastore" {  
  description = "The datastore to use for the VM"  
  type        = string  
}  

variable "resource_pool" {  
  description = "The resource pool to place the VM in"  
  type        = string  
}  

variable "template" {  
  description = "The template to use for the VM"  
  type        = string  
} 

variable "vmname" {  
  description = "The name of the virtual machine"  
  type        = string  
}  

variable "instances" {  
  description = "Number of instances to create"  
  type        = number  
}  

variable "cpu_number" {  
  description = "Number of CPUs for the VM"  
  type        = number  
}  

variable "ram_size" {  
  description = "Amount of RAM for the VM in MB"  
  type        = number  
}  

variable "network" {  
  description = "Network configuration for the VM"  
  type        = map(list(string))  # Alterado para corresponder à estrutura fornecida  
}  

variable "disk_size" {  
  description = "Size of the disk in GB"  
  type        = number  
}  

 

variable "vsphere_cluster" {  
  description = "The vSphere cluster where the VM will reside"  
  type        = string  
}  

variable "mask" {  
  description = "Subnet mask for the VM's network"  
  type        = list(number)  # Usando list para corresponder à estrutura fornecida  
}  

variable "gateway" {  
  description = "Gateway IP address for the VM"  
  type        = string  
}
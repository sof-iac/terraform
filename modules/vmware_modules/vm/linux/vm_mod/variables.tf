variable "vmname" {  
  description = "The name of the virtual machine"  
  type        = string  
}  

variable "resource_pool" {  
  description = "The resource pool to place the VM in"  
  type        = string  
}  

variable "datastore" {  
  description = "The datastore to use for the VM"  
  type        = string  
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
  description = "Network ID for the VM"  
  type        = string  
}  

variable "disk_size" {  
  description = "Size of the disk in GB"  
  type        = number  
}
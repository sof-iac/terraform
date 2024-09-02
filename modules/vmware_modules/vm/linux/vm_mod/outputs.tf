output "vm_id" {  
  description = "The ID of the virtual machine"  
  value       = vsphere_virtual_machine.vm.id  
}  

output "vm_ip" {  
  description = "The IP address of the virtual machine"  
  value       = vsphere_virtual_machine.vm.default_ip_address  
}
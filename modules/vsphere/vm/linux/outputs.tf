# -------------------------------------------------------------------
# Outputs for the vSphere Linux VM module
# All outputs are maps keyed by VM name (e.g. "TELK01", "TKBN171")
# -------------------------------------------------------------------

output "vm_names" {
  description = "Names of all created VMs."
  value       = { for k, vm in vsphere_virtual_machine.vm : k => vm.name }
}

output "vm_ids" {
  description = "vSphere managed object IDs (MOIDs) of all created VMs. Useful as references in other modules."
  value       = { for k, vm in vsphere_virtual_machine.vm : k => vm.id }
}

output "vm_ipv4_addresses" {
  description = "Primary IPv4 address of each VM as reported by VMware Tools after boot."
  value       = { for k, vm in vsphere_virtual_machine.vm : k => vm.default_ip_address }
}

output "vm_all_ip_addresses" {
  description = "All IP addresses (all interfaces, all protocols) of each VM as reported by VMware Tools."
  value       = { for k, vm in vsphere_virtual_machine.vm : k => vm.guest_ip_addresses }
}

output "vm_guest_id" {
  description = "Guest OS identifier for each VM (e.g. 'ubuntu64Guest')."
  value       = { for k, vm in vsphere_virtual_machine.vm : k => vm.guest_id }
}

output "vm_num_cpus" {
  description = "Number of vCPUs assigned to each VM."
  value       = { for k, vm in vsphere_virtual_machine.vm : k => vm.num_cpus }
}

output "vm_memory" {
  description = "Amount of memory in MB assigned to each VM."
  value       = { for k, vm in vsphere_virtual_machine.vm : k => vm.memory }
}

output "vm_disks" {
  description = "Disk configuration for each VM."
  value       = { for k, vm in vsphere_virtual_machine.vm : k => vm.disk }
}

output "vm_network_interfaces" {
  description = "Network interface configuration for each VM, including MAC addresses."
  value       = { for k, vm in vsphere_virtual_machine.vm : k => vm.network_interface }
}

output "vm_datastore_id" {
  description = "Datastore ID where each VM is stored. Reflects the actual placement, even when using Storage DRS."
  value       = { for k, vm in vsphere_virtual_machine.vm : k => vm.datastore_id }
}

output "vm_resource_pool_id" {
  description = "Resource pool ID each VM is placed in."
  value       = { for k, vm in vsphere_virtual_machine.vm : k => vm.resource_pool_id }
}

output "vm_folder" {
  description = "vSphere folder path each VM is placed in."
  value       = { for k, vm in vsphere_virtual_machine.vm : k => vm.folder }
}

output "vm_uuid" {
  description = "BIOS UUID of each VM. Useful for OS-level identification and external tooling."
  value       = { for k, vm in vsphere_virtual_machine.vm : k => vm.uuid }
}

output "vm_vmware_tools_status" {
  description = "VMware Tools running status for each VM."
  value       = { for k, vm in vsphere_virtual_machine.vm : k => vm.vmware_tools_status }
}

output "vm_power_state" {
  description = "Current power state of each VM (e.g. 'poweredOn', 'poweredOff')."
  value       = { for k, vm in vsphere_virtual_machine.vm : k => vm.power_state }
}

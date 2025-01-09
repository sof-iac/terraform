output "resource_pools" {
  description = "Resource pools"
  value       = vsphere_resource_pool.resource_pool
}

output "hosts" {
  description = "Hosts"
  value       = vsphere_host.host
  sensitive   = true
}
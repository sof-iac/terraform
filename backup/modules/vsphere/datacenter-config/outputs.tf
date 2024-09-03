output "dc_id" {
  description = "ID do datacenter"
  value       = vsphere_datacenter.datacenter.moid  
}

output "datastore_clusters" {
  description = "Datastore clusters"
  value       = vsphere_datastore_cluster.datastore_cluster
}

output "resource_pools" {
  description = "Resource pools"
  value       = vsphere_resource_pool.resource_pool
}
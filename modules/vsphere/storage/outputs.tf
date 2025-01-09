output "datastores" {
  description = "Datastores"
  value       = vsphere_vmfs_datastore.datastore
}

output "datastore_clusters" {
  description = "Datastore clusters"
  value       = vsphere_datastore_cluster.datastore_cluster
}
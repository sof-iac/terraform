output "dc_id" {
  description = "ID do datacenter"
  value       = vsphere_datacenter.datacenter.moid  
}

output "vsphere_tag_category" {
  value = vsphere_tag_category.category
}

output "tag" {
  value = vsphere_tag.tag
}
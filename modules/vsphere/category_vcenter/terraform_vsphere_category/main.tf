resource "vsphere_tag_category" "category" {
  name             = var.category_name
  description      = var.category_description
  cardinality      = var.cardinality
  associable_types = var.associable_types
}

output "vsphere_tag_category" {
  value = vsphere_tag_category.category.id
}

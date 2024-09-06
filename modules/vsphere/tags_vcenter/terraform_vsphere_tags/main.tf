    resource "vsphere_tag_category" "category" {
      name        = var.category_name
      description = var.category_description
      cardinality = "SINGLE"
      associable_types = ["VirtualMachine"]
    }

    resource "vsphere_tag" "tag" {
      name        = var.tag_name
      description = var.tag_description
      category_id = vsphere_tag_category.category.id
    }

    output "tag_id" {
      value = vsphere_tag.tag.id
    }
    resource "vsphere_tag_category" "category" {
      name        = var.category_name
      description = var.category_description
      cardinality = "MANY"
      associable_types = ["VirtualMachine"]
    }

    output "vsphere_tag_category" {
      value = vsphere_category.category.id
    }
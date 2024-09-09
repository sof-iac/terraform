    resource "vsphere_category" "category" {
      name        = var.category_name
      description = var.category_description
      cardinality = "MANY"
      associable_types = ["VirtualMachine"]
    }

    output "category_id" {
      value = vsphere_category.category.id
    }
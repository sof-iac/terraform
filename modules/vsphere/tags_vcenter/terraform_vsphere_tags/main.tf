    data "vsphere_tag_category" "category" {  
      name = var.category_name  # Nome da sua categoria  
    }  

    resource "vsphere_tag" "tag" {
      name        = var.tag_name
      description = var.tag_description
      category_id = data.vsphere_tag_category.category.id
    }

    output "tag_id" {
      value = vsphere_tag.tag.id
    }
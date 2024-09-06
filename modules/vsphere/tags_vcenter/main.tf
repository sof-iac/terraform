module "terraform_vsphere_tags" {

  source    = "./terraform_vsphere_tags"

  for_each = var.tag
  
  category_name        = each.value.category_name
  category_description = each.value.category_description
  tag_name             = each.value.tag_name
  tag_description      = each.value.tag_description  
}
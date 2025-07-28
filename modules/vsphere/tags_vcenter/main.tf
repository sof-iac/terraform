module "terraform_vsphere_tags" {

  source    = "./terraform_vsphere_tags"

  for_each = var.tag
  
  category_name        = each.value.category_name
  tag_name             = each.value.tag_name
  tag_description      = each.value.tag_description  
}
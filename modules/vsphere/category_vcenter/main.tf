module "terraform_vsphere_category" {

  source    = "./terraform_vsphere_category"

  for_each = var.category
  
  category_name        = each.value.category_name
  category_description = each.value.category_description
}
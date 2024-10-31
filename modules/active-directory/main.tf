resource "ad_ou" "ou" { 

  for_each = var.org-unit

  name        = each.key
  path        = each.value.path
  description = each.value.description
  protected   = each.value.protected
}
terraform {
  required_providers {
    vsphere = {
      source = "hashicorp/vsphere"
      version = "~> 2.10.0"
    }
  }
}

resource "vsphere_datacenter" "datacenter" {
  name = var.datacenter.dc-name
  tags = var.datacenter.tags
}

resource "vsphere_custom_attribute" "attribute" {
  for_each = var.attributes

  name                = each.key
  managed_object_type = each.value.object-type
}

resource "vsphere_tag_category" "category" {
  for_each = var.categories

  name             = each.key
  description      = each.value.description
  cardinality      = each.value.cardinality
  associable_types = each.value.types
}

resource "vsphere_tag" "tag" {
  for_each = var.tags

  name        = each.key
  description = each.value.description
  category_id = vsphere_tag_category.category[each.value.category].id
}

resource "vsphere_folder" "folder" {
  for_each = var.folders

  path          = each.key #each.value.parent == null ? each.key : "${vsphere_folder.folder[each.value.parent].path}/${each.key}"
  type          = each.value.type
  datacenter_id = vsphere_datacenter.datacenter.moid
}
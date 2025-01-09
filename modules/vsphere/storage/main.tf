terraform {
  required_providers {
    vsphere = {
      source = "hashicorp/vsphere"
      version = "~> 2.10.0"
    }
  }
}

resource "vsphere_vmfs_datastore" "datastore" {
  for_each = var.datastore

  name           = each.key
  folder         = each.value.folder
  host_system_id = each.value.host-id
  disks          = each.value.disks
  tags           = each.value.tags
}

resource "vsphere_datastore_cluster" "datastore_cluster" {
  for_each = var.datastore-cluster

  name          = each.key
  datacenter_id = each.value.datacenter-id

  sdrs_enabled                           = each.value.sdrs.enabled
  sdrs_automation_level                  = each.value.sdrs.enabled ? each.value.sdrs.automation-level : null
  sdrs_free_space_threshold              = null
  sdrs_free_space_utilization_difference = each.value.sdrs.enabled ? each.value.sdrs.free-space-utilization-diff : null
  sdrs_io_balance_automation_level       = each.value.sdrs.enabled ? each.value.sdrs.io-balance-automation-level : null
  sdrs_io_latency_threshold              = each.value.sdrs.enabled ? each.value.sdrs.io-latency-threshold : null
  sdrs_io_load_imbalance_threshold       = each.value.sdrs.enabled ? each.value.sdrs.io-load-imbalance-threshold : null
  sdrs_load_balance_interval             = each.value.sdrs.enabled ? each.value.sdrs.load-balance-interval : null
  sdrs_space_balance_automation_level    = each.value.sdrs.enabled ? each.value.sdrs.space-balance-automation-level : null
  sdrs_space_utilization_threshold       = each.value.sdrs.enabled ? each.value.sdrs.space-utilization-threshold : null
}
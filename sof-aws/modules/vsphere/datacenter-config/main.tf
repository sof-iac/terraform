resource "vsphere_datacenter" "datacenter" {
  name = var.datacenter.dc-name
  tags = var.datacenter.tags
}

resource "vsphere_datastore_cluster" "datastore_cluster" {
  for_each = var.datastore-cluster

  name          = each.key
  datacenter_id = vsphere_datacenter.datacenter.moid

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

resource "vsphere_compute_cluster" "compute_cluster" {
  for_each = var.compute-cluster

  name            = each.key
  datacenter_id   = vsphere_datacenter.datacenter.moid
  folder          = each.value.folder
  host_system_ids = each.value.host-ids
  
  drs_enabled          = each.value.drs.enabled
  drs_automation_level = each.value.drs.automation-level
  drs_advanced_options = each.value.drs.advanced-options

  dpm_enabled          = each.value.drs.enabled ? each.value.dpm.enabled : null
  dpm_automation_level = each.value.drs.enabled ? each.value.dpm.automation-level : null

  ha_enabled                       = each.value.ha.enabled
  ha_datastore_apd_recovery_action = each.value.ha.enabled ? each.value.ha.datastore-apd-recovery-action : null
  ha_datastore_apd_response        = each.value.ha.enabled ? each.value.ha.datastore-apd-response : null
  ha_datastore_apd_response_delay  = each.value.ha.enabled ? each.value.ha.datastore-apd-response-delay : null
  ha_datastore_pdl_response        = each.value.ha.enabled ? each.value.ha.datastore-pdl-response : null
  ha_vm_maximum_failure_window     = each.value.ha.enabled ? each.value.ha.vm-maximum-failure-window : null
  ha_advanced_options              = each.value.ha.enabled ? each.value.ha.advanced-options : null

  tags = each.value.tags
}

resource "vsphere_resource_pool" "resource_pool" {
  for_each = var.resource-pool

  name                    = each.key
  parent_resource_pool_id = vsphere_compute_cluster.compute_cluster[each.value.cluster-name].resource_pool_id
  cpu_share_level         = each.value.cpu-share-level
  memory_share_level      = each.value.memory-share-level
}
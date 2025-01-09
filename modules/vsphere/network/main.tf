terraform {
  required_providers {
    vsphere = {
      source = "hashicorp/vsphere"
      version = "~> 2.10.0"
    }
  }
}

resource "vsphere_distributed_virtual_switch" "vds" {
  for_each = var.vds

  name          = each.key
  datacenter_id = each.value.datacenter

  ignore_other_pvlan_mappings      = each.value.ignore-other-pvlan-mappings
  netflow_sampling_rate            = each.value.netflow-sampling-rate
  network_resource_control_enabled = each.value.network-resource-control-enabled
  tags                             = each.value.tags
  
  dynamic "host" {
    for_each = each.value.hosts
    content {
      host_system_id = host.value.host-id
      devices        = host.value.devices
    }
  } 
}

resource "vsphere_distributed_port_group" "pg" {
  for_each = var.pg

  name                            = each.key
  distributed_virtual_switch_uuid = vsphere_distributed_virtual_switch.vds[each.value.vds].id
  vlan_id                         = each.value.vlan-id

  dynamic "vlan_range" {
    for_each = (each.value.vlan-range == null) ? [] : each.value.vlan-range
    content {
      min_vlan = vlan_range.value.min-vlan
      max_vlan = vlan_range.value.max-vlan
    }
  }
  
  auto_expand                     = each.value.auto-expand
  block_override_allowed          = each.value.block-override-allowed
  network_resource_pool_key       = each.value.network-resource-pool-key
  port_config_reset_at_disconnect = each.value.port-config-reset-at-disconnect
}
terraform {
  required_providers {
    vsphere = {
      source = "hashicorp/vsphere"
      version = "~> 2.10.0"
    }
  }
}

#data "vsphere_host_thumbprint" "thumbprint" {
#  for_each = var.host
#
#  address = each.key
#}

resource "vsphere_host" "host" {
  for_each = var.host

  hostname        = each.key
  username        = each.value.username
  password        = each.value.password
  license         = each.value.license
  thumbprint      = each.value.thumbprint #data.vsphere_host_thumbprint.thumbprint[each.key].id
  cluster_managed = each.value.cluster-managed
  datacenter      = each.value.cluster-managed ? null : each.value.datacenter-id
  maintenance     = each.value.maintenance
  
  # TF atualmente suporta apenas o ntpd na lista de services. Caso novos serviços sejam adicionados, incluir um dynamic block aqui
  services {
    ntpd {
      enabled     = each.value.services.enabled
      policy      = each.value.services.policy
      ntp_servers = each.value.services.ntp-servers  
    }
  }
}

resource "vsphere_compute_cluster" "compute_cluster" {
  for_each = var.compute-cluster

  name            = each.key
  datacenter_id   = each.value.datacenter-id
  folder          = each.value.folder
  host_system_ids = [for hostname in each.value.hosts : vsphere_host.host[hostname].id]
  
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

  name                     = each.key
  parent_resource_pool_id  = vsphere_compute_cluster.compute_cluster[each.value.compute-cluster].resource_pool_id
  cpu_share_level          = each.value.cpu-share-level
  memory_share_level       = each.value.memory-share-level
  scale_descendants_shares = each.value.scale-descendants-shares
}
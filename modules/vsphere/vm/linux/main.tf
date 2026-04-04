# -------------------------------------------------------------------
# vSphere Linux VM – merged module (direct template, Linux only)
# Iterates over var.vm map; each key becomes the VM name prefix.
# -------------------------------------------------------------------

locals {
  # Number of disks per template, keyed by VM name (each.key in var.vm)
  template_disk_count = {
    for k, v in data.vsphere_virtual_machine.template : k => length(v.disks)
  }
}

# ── vSphere data sources ────────────────────────────────────────────

data "vsphere_datacenter" "dc" {
  for_each = var.vm
  name     = each.value.datacenter
}

data "vsphere_datastore_cluster" "datastore_cluster" {
  for_each      = { for k, v in var.vm : k => v if v.datastore_cluster != "" }
  name          = each.value.datastore_cluster
  datacenter_id = data.vsphere_datacenter.dc[each.key].id
}

data "vsphere_datastore" "datastore" {
  for_each      = { for k, v in var.vm : k => v if v.datastore != "" }
  name          = each.value.datastore
  datacenter_id = data.vsphere_datacenter.dc[each.key].id
}

data "vsphere_resource_pool" "pool" {
  for_each      = { for k, v in var.vm : k => v if v.resource_pool != "" }
  name          = each.value.resource_pool
  datacenter_id = data.vsphere_datacenter.dc[each.key].id
}

data "vsphere_network" "network" {
  for_each      = { for pair in flatten([
    for vm_key, v in var.vm : [
      for net_key in keys(v.network) : {
        id     = "${vm_key}__${net_key}"
        vm_key = vm_key
        net    = net_key
      }
    ]
  ]) : pair.id => pair }
  name          = each.value.net
  datacenter_id = data.vsphere_datacenter.dc[each.value.vm_key].id
}

data "vsphere_virtual_machine" "template" {
  for_each      = var.vm
  name          = each.value.template
  datacenter_id = data.vsphere_datacenter.dc[each.key].id
}

data "vsphere_tag_category" "category" {
  for_each = { for pair in flatten([
    for vm_key, v in var.vm : [
      for cat in keys(coalesce(v.tags, {})) : {
        id     = "${vm_key}__${cat}"
        vm_key = vm_key
        cat    = cat
      }
    ]
  ]) : pair.id => pair }
  name = each.value.cat
}

data "vsphere_tag" "tag" {
  for_each = { for pair in flatten([
    for vm_key, v in var.vm : [
      for cat, tag in coalesce(v.tags, {}) : {
        id     = "${vm_key}__${cat}"
        vm_key = vm_key
        cat    = cat
        tag    = tag
      }
    ]
  ]) : pair.id => pair }
  name        = each.value.tag
  category_id = data.vsphere_tag_category.category[each.key].id
}

# ── Virtual machines ────────────────────────────────────────────────

resource "vsphere_virtual_machine" "vm" {
  for_each = {
    for pair in flatten([
      for vm_key, v in var.vm : [
        for i in range(v.instances) : {
          id       = lookup(v, "staticvmname", null) != null ? v.staticvmname : format(can(regex("[0-9]$", vm_key)) ? "%s%d" : "%s%02d", vm_key, i + lookup(v, "vmstartcount", 0))
          vm_key   = vm_key
          index    = i + lookup(v, "vmstartcount", 0)  # used for display name only
          ip_index = i                                  # zero-based, used for IP list lookups
          v        = v
        }
      ]
    ]) : pair.id => pair
  }

  name = each.key

  resource_pool_id = data.vsphere_resource_pool.pool[each.value.vm_key].id
  folder           = lookup(each.value.v, "vmfolder", null)
  annotation       = lookup(each.value.v, "annotation", null)
  tags             = each.value.v.tags != null ? [
    for cat in keys(each.value.v.tags) :
    data.vsphere_tag.tag["${each.value.vm_key}__${cat}"].id
  ] : []

  firmware                = data.vsphere_virtual_machine.template[each.value.vm_key].firmware
  efi_secure_boot_enabled = data.vsphere_virtual_machine.template[each.value.vm_key].efi_secure_boot_enabled
  enable_disk_uuid        = data.vsphere_virtual_machine.template[each.value.vm_key].enable_disk_uuid
  guest_id                = data.vsphere_virtual_machine.template[each.value.vm_key].guest_id
  scsi_type               = data.vsphere_virtual_machine.template[each.value.vm_key].scsi_type

  datastore_cluster_id = (
    lookup(each.value.v, "datastore_cluster", "") != ""
    ? data.vsphere_datastore_cluster.datastore_cluster[each.value.vm_key].id
    : null
  )
  datastore_id = (
    lookup(each.value.v, "datastore", "") != ""
    ? data.vsphere_datastore.datastore[each.value.vm_key].id
    : null
  )

  num_cpus             = each.value.v.cpu
  memory               = each.value.v.memory
  cpu_hot_add_enabled  = lookup(each.value.v, "cpu_hot_add_enabled", false)
  memory_hot_add_enabled = lookup(each.value.v, "memory_hot_add_enabled", false)

  scsi_controller_count = max(
    max(0, flatten([
      for item in values(lookup(each.value.v, "data_disk", {})) : [
        for elem, val in item :
        elem == "data_disk_scsi_controller" ? val : 0
      ]
    ])...) + 1,
    1
  )

  wait_for_guest_net_routable = lookup(each.value.v, "wait_for_guest_net_routable", true)
  wait_for_guest_ip_timeout   = lookup(each.value.v, "wait_for_guest_ip_timeout", 0)
  wait_for_guest_net_timeout  = lookup(each.value.v, "wait_for_guest_net_timeout", 5)

  # ── Network interfaces ──────────────────────────────────────────
  # Use network_if_order to guarantee interface sequence (and thus gateway assignment).
  # Falls back to lexicographic key order when omitted.

  dynamic "network_interface" {
    for_each = coalesce(each.value.v.network_if_order, keys(each.value.v.network))
    content {
      network_id   = data.vsphere_network.network["${each.value.vm_key}__${network_interface.value}"].id
      adapter_type = (
        lookup(each.value.v, "network_type", null) != null
        ? each.value.v.network_type[network_interface.key]
        : data.vsphere_virtual_machine.template[each.value.vm_key].network_interface_types[0]
      )
    }
  }

  # ── Disks from template ─────────────────────────────────────────

  dynamic "disk" {
    for_each = data.vsphere_virtual_machine.template[each.value.vm_key].disks
    iterator = template_disks
    content {
      label            = "disk${template_disks.key}"
      size             = template_disks.value.size
      unit_number      = template_disks.key
      thin_provisioned = template_disks.value.thin_provisioned
      eagerly_scrub    = template_disks.value.eagerly_scrub
      io_share_level   = "normal"
      io_reservation   = (
        each.value.v.template_disk_io_reservation != null
        ? each.value.v.template_disk_io_reservation[template_disks.key]
        : null
      )
    }
  }

  # ── Additional data disks ───────────────────────────────────────

  dynamic "disk" {
    for_each = lookup(each.value.v, "data_disk", {})
    iterator = terraform_disks
    content {
      label = terraform_disks.key
      size  = lookup(terraform_disks.value, "size_gb", null)
      unit_number = (
        lookup(terraform_disks.value, "unit_number", -1) < 0 ? (
          lookup(terraform_disks.value, "data_disk_scsi_controller", 0) > 0 ? (
            (terraform_disks.value.data_disk_scsi_controller * 15) +
            index(keys(lookup(each.value.v, "data_disk", {})), terraform_disks.key) +
            local.template_disk_count[each.value.vm_key]
          ) : (
            index(keys(lookup(each.value.v, "data_disk", {})), terraform_disks.key) + local.template_disk_count[each.value.vm_key]
          )
        ) : tonumber(terraform_disks.value["unit_number"])
      )
      thin_provisioned  = lookup(terraform_disks.value, "thin_provisioned", true)
      eagerly_scrub     = lookup(terraform_disks.value, "eagerly_scrub", false)
      datastore_id      = lookup(terraform_disks.value, "datastore_id", null)
      storage_policy_id = lookup(terraform_disks.value, "storage_policy_id", null)
      io_share_level    = lookup(terraform_disks.value, "io_share_level", "normal")
      io_share_count    = lookup(terraform_disks.value, "io_share_level", null) == "custom" ? lookup(terraform_disks.value, "io_share_count") : null
      disk_mode         = lookup(terraform_disks.value, "disk_mode", null)
    }
  }

  # ── Clone + customization ───────────────────────────────────────

  clone {
    template_uuid = data.vsphere_virtual_machine.template[each.value.vm_key].id
    linked_clone  = false
    timeout       = lookup(each.value.v, "timeout", 30)

    customize {
      linux_options {
        host_name    = each.key
        domain       = each.value.v.domain
        hw_clock_utc = lookup(each.value.v, "hw_clock_utc", true)
        time_zone    = lookup(each.value.v, "time_zone", null)
      }

      dynamic "network_interface" {
        for_each = coalesce(each.value.v.network_if_order, keys(each.value.v.network))
        content {
          ipv4_address = split("/", each.value.v.network[network_interface.value][each.value.ip_index])[0]
          ipv4_netmask = (
            length(split("/", each.value.v.network[network_interface.value][each.value.ip_index])) == 2
            ? split("/", each.value.v.network[network_interface.value][each.value.ip_index])[1]
            : (
              length(each.value.v.mask) == 1
              ? each.value.v.mask[0]
              : each.value.v.mask[network_interface.key]
            )
          )
        }
      }

      dns_server_list = lookup(each.value.v, "dns_server_list", [])
      dns_suffix_list = lookup(each.value.v, "dns_suffix_list", [])
      ipv4_gateway    = each.value.v.gateway
    }
  }

  shutdown_wait_timeout = lookup(each.value.v, "shutdown_wait_timeout", 3)
  force_power_off       = lookup(each.value.v, "force_power_off", false)
}

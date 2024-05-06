# modules/Ubuntu_Cloud/main.tf

data "vsphere_datacenter" "dc" {
  name          = var.datacenter
}

data "vsphere_datastore" "datastore" {
  name          = var.datastore
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_compute_cluster" "cluster" {
  name          = var.cluster
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network" {
  name          = var.network
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_virtual_machine" "template" {
  name          = var.template
  datacenter_id = data.vsphere_datacenter.dc.id
}

resource "vsphere_virtual_machine" "vm" {
  count             = var.vm_count
  name              = upper(format("%s%02d", var.name_prefix, count.index + 1))
  resource_pool_id  = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id      = data.vsphere_datastore.datastore.id

  num_cpus          = var.cpus
  memory            = var.memory
  guest_id          = data.vsphere_virtual_machine.template.guest_id

  scsi_type = data.vsphere_virtual_machine.template.scsi_type

  network_interface {
    network_id       = data.vsphere_network.network.id
    adapter_type     = data.vsphere_virtual_machine.template.network_interface_types[0]
  }

  disk {
    label            = "disk0"
    size             = data.vsphere_virtual_machine.template.disks.0.size
    eagerly_scrub    = data.vsphere_virtual_machine.template.disks.0.eagerly_scrub
    thin_provisioned = data.vsphere_virtual_machine.template.disks.0.thin_provisioned
  }

  cdrom {
    client_device = true
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template.id

    customize {
      linux_options {
        host_name = var.hostname
        domain    = var.domain
      }

      network_interface {
        ipv4_address = format("%s.%d", regex("^[0-9]+.[0-9]+.[0-9]+", var.vm_ip), regex("[0-9]+$", var.vm_ip) + count.index)
        ipv4_netmask = var.netmask
      }

      ipv4_gateway    = var.gateway
      dns_server_list = [var.dns]
    }
  }

  vapp {
    properties = {
      "user-data" = base64encode(<<-EOT
        #cloud-config
        hostname: "${var.hostname}"

        users:
        - name: "${var.vm_user}"
          passwd: "${var.vm_pass}"
          lock_passwd: false
          sudo: 'ALL=(ALL) ALL'
          groups: [adm, audio, cdrom, dialout, floppy, video, plugdev, dip, netdev]
          ssh-authorized-keys:
          - "${var.ssh_key}"
        EOT
      )
    }
  }
}

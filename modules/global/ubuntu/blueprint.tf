locals {
  templatevars = {
    name         = var.name,
    ipv4_address = var.ipv4_address,
    ipv4_gateway = var.ipv4_gateway,
    dns_server_1 = var.dns_server_list[0],
    dns_server_2 = var.dns_server_list[1],
    public_key   = var.public_key,
    ssh_username = var.ssh_username,
    ssh_password = var.ssh_password,
    svc_username = var.svc_username,
    svc_password = var.svc_password,
    host_name    = var.host_name,
  }
}

variable "vmname" {
  type        = string
  description = "VM Name"
  default = "ubuntu01tf"
}


provider "vsphere" {
  allow_unverified_ssl = true
}

data "vsphere_datacenter" "dc" {
  name = "SOF"
}

data "vsphere_datastore_cluster" "datastore_cluster" {
  name          = "Storage_Purestorage"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_resource_pool" "pool" {
  name          = "Blade_Atreus/Resources" 
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_network" "network" {
  name          = "PG_Atlas_Teste" 
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_virtual_machine" "template" {
  name          = "templateubuntu2204"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

resource "tls_private_key" "public_private_key_pair" {
  algorithm   = "RSA"
}

resource "vsphere_virtual_machine" "vmorcl" {
  name             = "${var.vmname}"
  resource_pool_id = "${data.vsphere_resource_pool.pool.id}"
  datastore_cluster_id     = "${data.vsphere_datastore_cluster.datastore_cluster.id}"

  num_cpus = 4
  memory   = 8192
  guest_id = "ubuntu64Guest"
  firmware = "${data.vsphere_virtual_machine.template.firmware}"

  network_interface {
    network_id = "${data.vsphere_network.network.id}"
    adapter_type = data.vsphere_virtual_machine.template.network_interface_types[0]
  }

  dynamic "disk" {
    for_each = "${data.vsphere_virtual_machine.template.disks}"
      content {
        label = "${disk.value["label"]}"
        size = disk.value["size"]
        unit_number = disk.value["unit_number"]
        thin_provisioned  = disk.value["thin_provisioned"]
      }
  }
  extra_config = {
    "guestinfo.metadata"          = base64encode(templatefile("${path.module}/templates/metadata.yaml", local.templatevars))
    "guestinfo.metadata.encoding" = "base64"
    "guestinfo.userdata"          = base64encode(templatefile("${path.module}/templates/userdata.yaml", local.templatevars))
    "guestinfo.userdata.encoding" = "base64"
  }  
  clone {
    template_uuid = "${data.vsphere_virtual_machine.template.id}"
    customize {
      linux_options {
        host_name = "${var.host_name}"
        domain    = "sof.intra"
      }
      network_interface {
        ipv4_address = "${var.ipv4_address}"
        ipv4_netmask = "24"
      }
      ipv4_gateway = "1192.168.30.1"
      dns_server_list = ["172.27.3.5", "172.27.3.6"]
    }
  }
  provisioner "file" {
    source      = "setup-ansible-user"
    destination = "/tmp/setup-ansible-user"
    connection {
      type     = "ssh"
      user     = "${var.ssh_username}"
      password = "${var.ssh_password}"
      # private_key = file(var.privatekeypath)
      host     = "${var.ipv4_address}"
    }
  }
  provisioner "file" {
    source      = "id_ed25519"
    destination = "/tmp/"
    connection {
      type     = "ssh"
      user     = "${var.ssh_username}"
      password = "${var.ssh_password}"
      # private_key = file(var.privatekeypath)
      host     = "${var.ipv4_address}"
    }
  }
  provisioner "file" {
    source      = "id_ed25519.pub"
    destination = "/tmp/"
    connection {
      type     = "ssh"
      user     = "${var.ssh_username}"
      password = "${var.ssh_password}"
      # private_key = file(var.privatekeypath)
      host     = "${var.ipv4_address}"
    }
  }
  # Muda as permissões para ser executado
  provisioner "remote-exec" {
    connection {
      type     = "ssh"
      user     = "${var.ssh_username}"
      password = "${var.ssh_password}"
      # private_key = file(var.privatekeypath)
      host     = "${var.ipv4_address}"
    }
    inline = [
      "chmod +x /tmp/setup-ansible-user",
      "/tmp/setup-ansible-user ${var.svc_password}",
      "echo 'options edns0 trust-ad' > /etc/resolv.conf",
      "echo 'nameserver 172.27.3.5' >> /etc/resolv.conf",
      "echo 'nameserver 172.27.3.6' >> /etc/resolv.conf",
      "echo 'nameserver 172.27.3.7' >> /etc/resolv.conf",
      "echo 'search sof.intra blocok.sof.remoto' >> /etc/resolv.conf",
      "echo 192.168.250.163         PREP02 >> /etc/hosts",
      "echo 192.168.250.125         PREP01 >> /etc/hosts",
    ]
  }
  wait_for_guest_net_timeout    = -1
}
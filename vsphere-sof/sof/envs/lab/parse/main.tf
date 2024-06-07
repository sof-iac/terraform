
locals {
  templatevars = {
    name            = var.name,
    host_name       = var.host_name,
    cpus            = var.cpus
    memory          = var.memory
    vm_domain       = var.vm_domain
    ipv4_address    = var.ipv4_address
    ipv4_gateway    = var.ipv4_gateway
    disco_adicional = var.disco_adicional
    disksize        = var.disksize
    annotation      = var.annotation
    svc_username    = var.svc_username
    svc_password    = var.svc_password
    distro          = var.distro
  }
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


#data "vsphere_datastore" "datastore" {
  #name          = var.vsphere_datastore
  #datacenter_id = data.vsphere_datacenter.dc.id
#}

#data "vsphere_compute_cluster" "cluster" {
  #name          = var.vsphere_cluster
  #datacenter_id = data.vsphere_datacenter.dc.id
#}

data "vsphere_network" "network" {
  name          = var.vsphere_network
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_virtual_machine" "template" {
  name          = var.template
  datacenter_id = data.vsphere_datacenter.dc.id
}

resource "vsphere_virtual_machine" "vm" {
  count             = var.vm_count
  name              = var.host_name
  # name -> ideal para varias maquinas partindo do principio que o prefixo ainda nao exista ou a partir de uma sequencia
  #name              = upper(format("%s%02d", var.name_prefix, count.index + 1))
  resource_pool_id = "${data.vsphere_resource_pool.pool.id}"
  datastore_cluster_id     = "${data.vsphere_datastore_cluster.datastore_cluster.id}"
  #resource_pool_id  = data.vsphere_compute_cluster.cluster.id
 # datastore_id      = data.vsphere_datastore.datastore.id

  num_cpus          = var.cpus
  memory            = var.memory
  guest_id          = data.vsphere_virtual_machine.template.guest_id
  annotation        = var.annotation
  scsi_type = data.vsphere_virtual_machine.template.scsi_type

  network_interface {
    network_id       = data.vsphere_network.network.id
    adapter_type     = data.vsphere_virtual_machine.template.network_interface_types[0]
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
  # Adicionar um disco complementar se disco_adicional for verdadeiro
  dynamic "disk" {
    for_each = var.disco_adicional ? [1] : []
    content {
      label            = "data_disk"
      size             = var.disksize
      unit_number      = length(data.vsphere_virtual_machine.template.disks) + 1
      thin_provisioned = true
    }
  }

  cdrom {
    client_device = true
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template.id

    customize {
      linux_options {
        host_name = var.host_name
        domain    = var.domain
      }

      network_interface {
        ipv4_address = var.ipv4_address
        ipv4_netmask = "24"
      }
      ipv4_gateway = var.ipv4_gateway
      dns_server_list = ["172.27.3.5", "172.27.3.6"]
    }
  }
  provisioner "file" {
    source      = "setup-ansible-user"
    destination = "/tmp/setup-ansible-user"
    connection {
      type     = "ssh"
      user     = "${var.svc_username}"
      password = "${var.svc_password}"
      # private_key = file(var.privatekeypath)
      host     = "${var.ipv4_address}"
    }
  }
  provisioner "file" {
    source      = "/home/ansible/.ssh/id_ed25519"
    destination = "/tmp/"
    connection {
      type     = "ssh"
      user     = "${var.svc_username}"
      password = "${var.svc_password}"
      # private_key = file(var.privatekeypath)
      host     = "${var.ipv4_address}"
    }
  }
  provisioner "file" {
    source      = "/home/ansible/.ssh/id_ed25519.pub"
    destination = "/tmp/"
    connection {
      type     = "ssh"
      user     = "${var.svc_username}"
      password = "${var.svc_password}"
      # private_key = file(var.privatekeypath)
      host     = "${var.ipv4_address}"
    }
  }
  # Muda as permissões para ser executado se ubuntu
  provisioner "remote-exec" {
    connection {
      type     = "ssh"
      user     = "${var.svc_username}"
      password = "${var.svc_password}"
      # private_key = file(var.privatekeypath)
      host     = "${var.ipv4_address}"
    } 
    inline = [
        "if [ \"${var.distro}\" == \"ubuntu\" ]; then",
            "chmod +x /tmp/setup-ansible-user",
            "/tmp/setup-ansible-user ${var.svc_password}",
            "echo 'options edns0 trust-ad' > /etc/systemd/resolved.conf",
            "echo 'nameserver 172.27.3.5' | tee -a /etc/systemd/resolved.conf",
            "echo 'nameserver 172.27.3.6' | tee -a /etc/systemd/resolved.conf",
            "echo 'nameserver 172.27.3.7' | tee -a /etc/systemd/resolved.conf",
            "echo 'search sof.intra blocok.sof.remoto' | tee -a /etc/systemd/resolved.conf",
            "echo 192.168.250.163         PREP02 | tee -a /etc/systemd/resolved.conf",
            "echo 192.168.250.125         PREP01 | tee -a /etc/systemd/resolved.conf",
            "systemctl restart systemd-resolved",
        "elif [ \"${var.distro}\" == \"centos\" ]; then",
            "chmod +x /tmp/setup-ansible-user",
            "/tmp/setup-ansible-user ${var.svc_password}",
            "echo 'options edns0 trust-ad' > /etc/resolv.conf",
            "echo 'nameserver 172.27.3.5' >> /etc/resolv.conf",
            "echo 'nameserver 172.27.3.6' >> /etc/resolv.conf",
            "echo 'nameserver 172.27.3.7' >> /etc/resolv.conf",
            "echo 'search sof.intra blocok.sof.remoto' >> /etc/resolv.conf",
            "echo 192.168.250.163         PREP02 >> /etc/hosts",
            "echo 192.168.250.125         PREP01 >> /etc/hosts",
        "fi"
    ]
  }  
}

output "datacenter_id" {
  value = data.vsphere_datacenter.dc.id
}

locals {
  templatevars = {
    name            = var.name,
    host_name       = var.host_name,
    cpus            = var.cpus,
    memory          = var.memory,
    vm_domain       = var.vm_domain,
    vsphere_cluster = var.vsphere_cluster,
    vsphere_network = var.vsphere_network,
    vsphere_resource_pool = var.vsphere_resource_pool    
    ipv4_address    = var.ipv4_address,
    ipv4_gateway    = var.ipv4_gateway,
    disco_adicional = var.disco_adicional,
    disksize        = var.disksize,
    annotation      = var.annotation,
    vm_user         = var.vm_user,
    vm_pass         = var.vm_pass,
    svc_username    = var.svc_username,
    svc_password    = var.svc_password,
    user_svc_passwd = var.user_svc_passwd,
    distro          = var.distro,
    public_key      = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJvaUICPun0zJo21vhsvaZpYegvpzZjxxkMQxPOF5xeL user_svc_puppet.sof.intra"
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
  name          = var.vsphere_resource_pool
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

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

  extra_config = {
    "guestinfo.userdata"          = base64encode(templatefile("${path.module}/templates/userdata.yaml", local.templatevars))
    "guestinfo.userdata.encoding" = "base64"
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
  # Tenta rebootar a maquina
  provisioner "remote-exec" {
    connection {
      type     = "ssh"
      user     = "${var.svc_username}"
      password = "${var.svc_password}"
      host     = "${var.ipv4_address}"
    }
    inline = [
      "echo 'Continuando após o reboot'",
    ]
  }
  # Copia a chave publica para a VM a ser criada
  provisioner "file" {
    source      = "/home/ansible/.ssh/id_ed25519.pub"
    destination = "/tmp/"
    connection {
      type     = "ssh"
      user     = "${var.vm_user}"
      password = "${var.vm_pass}"
      host     = "${var.ipv4_address}"
    }
  }  
  # Shel script para criação do usuario ansible, caso nao exista
  provisioner "file" {
    source      = "setup_ansible_user.sh"
    destination = "/tmp/setup_ansible_user.sh"
    connection {
      type     = "ssh"
      user     = "${var.vm_user}"
      password = "${var.vm_pass}"
      # private_key = file(var.privatekeypath)
      host     = "${var.ipv4_address}"
    }
  }
  # Shell script para configurar o dns e o sudoers
  provisioner "file" {
    source      = "config_dns.sh"
    destination = "/tmp/config_dns.sh"
    connection {
      type     = "ssh"
      user     = "${var.vm_user}"
      password = "${var.vm_pass}"
      host     = "${var.ipv4_address}"
    }
  }  
  # Executa os script de usuario e permissoes para GC
  provisioner "remote-exec" {
    connection {
      type     = "ssh"
      user     = "${var.vm_user}"
      password = "${var.vm_pass}"
      host     = "${var.ipv4_address}"
    } 
    inline = [
      "chmod +x /tmp/setup_ansible_user.sh",
      "/tmp/setup_ansible_user.sh ${var.svc_password}",
      "chmod +x /tmp/config_dns.sh",
      "/tmp/config_dns.sh ${var.distro}",
    ]
  }  
  # Quando este recurso é criado, executa o seguinte script localmente para dar permissões ao usuario ansible
  provisioner "remote-exec" {
    connection {
      type     = "ssh"
      user     = var.vm_user
      password = var.vm_pass
      host     = var.ipv4_address
    }
    inline = [
      "touch /etc/sudoers.d/ansible_automation",
      "echo 'User_Alias ANSIBLE_AUTOMATION = ansible' | tee -a /etc/sudoers.d/ansible_automation",
      "echo 'Defaults:ANSIBLE_AUTOMATION !requiretty' | tee -a /etc/sudoers.d/ansible_automation",
      "echo 'ANSIBLE_AUTOMATION ALL=(ALL) NOPASSWD: ALL' | tee -a /etc/sudoers.d/ansible_automation",
      "chmod 0440 /etc/sudoers.d/ansible_automation"
    ]
  }
  # Quando este recurso é criado, executa o seguinte script localmente para configurar o DNS
  provisioner "remote-exec" {
    connection {
      type     = "ssh"
      user     = var.vm_user
      password = var.vm_pass
      host     = var.ipv4_address
    }    
    inline = [
      "echo 'options edns0 trust-ad' > /etc/resolv.conf",
      "echo 'nameserver 172.27.3.5' >> /etc/resolv.conf",
      "echo 'nameserver 172.27.3.6' >> /etc/resolv.conf",
      "echo 'nameserver 172.27.3.7' >> /etc/resolv.conf",
      "echo 'search sof.intra blocok.sof.remoto' >> /etc/resolv.conf",
      "echo '192.168.250.163         PREP02' >> /etc/hosts",
      "echo '192.168.250.125         PREP01' >> /etc/hosts"
    ]
  }  
}

output "datacenter_id" {
  value = data.vsphere_datacenter.dc.id
}

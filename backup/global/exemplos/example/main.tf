# main.tf

module "create-vm" {
  source     = "../modules/instances/vsphere"

  # Vcenter Specs
  datacenter  = var.datacenter
  cluster     = var.cluster
  datastore   = var.datastore

  # VM Specs
  name_prefix = "k8s-master"
  vm_count    = 1
  domain      = "sof.intra"
  template    = "ubuntu-2204-cloudimg-template"
  network     = "PG_Atlas_Servico_Kubernets"
  cpus        = 4
  memory      = 8192

  # Network
  hostname    = "k8s-master"
  vm_ip       = "192.168.22.180"
  gateway     = "192.168.22.1"
  dns         = "172.27.3.5"
  netmask     = "24"

  # VM Credentials
  vm_user    = var.vm_user
  vm_pass    = var.vm_pass
  ssh_key    = var.ssh_key
}

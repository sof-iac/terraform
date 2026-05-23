terraform {
  source = "../../../../modules/vsphere/vm/linux"
}

include {
  path = find_in_parent_folders()
}

locals {
  vcenter        = basename(dirname(get_terragrunt_dir()))
  TF_VAR_VM_PASS = get_env("TF_VAR_VM_PASS")
}

inputs = {
  vm = {}
}

# PG_Dmz VLAN access: 2443
# Pg_Dominio_Recurso VLAN access: 2442
# PG_Gerencia VLAN access: 2440
# PG_Kubernetes VLAN access: 2444
# PG_Servico VLAN access: 2441
# PG_Dmz para os apaches.
# PG_Dmz - VLAN access: 2443 - rede 172.16.51.0/24
# Pg_Dominio_Recurso - VLAN access: 2442 - rede 192.168.80.0/24
# PG_Gerencia - VLAN access: 2440 - rede 192.168.240.0/24
# PG_Kubernetes - VLAN access: 2444 - rede 192.168.122.0/24
# PG_Servico - VLAN access: 2441 - rede 192.168.121.0/24

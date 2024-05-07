# Ambientes
Valores de referencia para ambientes de teste e produção no Vcenter

### Testes
```
data "vsphere_datastore_cluster" "datastore_cluster" {
  name          = "Storage_Purestorage"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_resource_pool" "pool" {
  name          = "DevOps_Atreus_Teste"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_network" "network" {
  name          = "PG_Atlas_Teste"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}
```

### Produção

```
data "vsphere_datastore_cluster" "datastore_cluster" {
  name          = "Storage_Purestorage"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_resource_pool" "pool" {
  name          = ""
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_network" "network" {
  name          = "PG_Gaia_App_Shared_MP"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}
```


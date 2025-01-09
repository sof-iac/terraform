terraform {
  source = "../../../../modules/vsphere/datacenter-config"
}

include {
  path = find_in_parent_folders()
}

inputs = {
  datacenter = {
    dc-name = "BLOCOK"
    tags    = [] 
  }

  attributes = {
    "AutoDeploy.MachineIdentity" = {
      object-type = "HostSystem"
    }
    "com.vmware.vcenter.cluster.edrs.upgradeHostAdded" = {
      object-type = "ClusterComputeResource"
    }
    "NB_LAST_BACKUP" = {
      object-type = "VirtualMachine"
    }
    "com.vmware.vcIntegrity.customField.scheduledTask.target" = {
      object-type = "ScheduledTask"
    }
    "com.vmware.vcIntegrity.customField.scheduledTask.action" = {
      object-type = "ScheduledTask"
    }
    "com.vmware.vcIntegrity.customField.scheduledTask.signature" = {
      object-type = "ScheduledTask"
    }
    "com.vrlcm.snapshot" = {
    }
  }

  categories = {
    "VM-SOF" = {
      description = "vcs-uncategorized-tag-description"
      cardinality = "MULTIPLE"
      types       = [
        "DistributedVirtualSwitch",
        "VmwareDistributedVirtualSwitch",
        "VirtualMachine",
        "DistributedVirtualPortgroup"
      ]
    }
    "Responsável" = {
      description = "Responsável"
      cardinality = "SINGLE"
      types       = [
        "VirtualMachine"
      ]
    }
    "k8s_region" = {
      description = "Região Kubernetes"
      cardinality = "SINGLE"
      types       = [
        "Datacenter"
      ]
    }
    "k8s_storage" = {
      description = "Storage Kubernetes"
      cardinality = "SINGLE"
      types       = [
        "Datastore",
        "Datacenter",
        "Folder"
      ]
    }
    "k8s_zone" = {
      description = "Zona Kubernetes"
      cardinality = "SINGLE"
      types       = [
        "Datastore",
        "StoragePod",
        "ClusterComputeResource"
      ]
    }
    "snapshots_vrops" = {
      description = "Tags referentes a snapshots (prazo, tamanho, etc) para serem usadas nas automações do vrops."
      cardinality = "SINGLE"
      types       = [
        "VirtualMachine"
      ]
    }
    "vSANDirectStorage" = {
      description = ""
      cardinality = "MULTIPLE"
      types       = [
        "Datastore"
      ]
    }
  }

  tags = {
    "k8s_region_SOF" = {
      description = ""
      category    = "k8s_region"
    }
    "snapshots_10_dias" = {
      description = "Tag para VM poder ficar com snapshot por até 10 dias."
      category    = "snapshots_vrops"
    }
    "CODIN" = {
      description = ""
      category    = "Responsável"
    }
    "k8s_storage_silver" = {
      description = ""
      category    = "k8s_storage"
    }
    "k8s_storage_minio" = {
      description = ""
      category    = "k8s_storage"
    }
    "k8s_zone_SOF" = {
      description = ""
      category    = "k8s_zone"
    }
    "k8s_storage_all" = {
      description = ""
      category    = "k8s_storage"
    }
    "Sof-Vshere-Ubuntu" = {
      description = "Sof-Vshere-Ubuntu"
      category    = "VM-SOF"
    }
    "k8s_storage_blocok" = {
      description = ""
      category    = "k8s_storage"
    }
    "k8s_storage_platinum" = {
      description = ""
      category    = "k8s_storage"
    }
    "k8s_storage_lab" = {
      description = ""
      category    = "k8s_storage"
    }
    "k8s_storage_gold" = {
      description = ""
      category    = "k8s_storage"
    }
  }

  folders = {
    "Disco_Local_SEM_USO" = {
      type       = "datastore"
    }
    "Templates_k" = {
      type       = "vm"
    }
    "VMware_BLOCOK" = {
      type       = "vm"
    }
  }
}
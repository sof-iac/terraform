include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../../../modules/vsphere/category_vcenter"  # Caminho relativo ao terragrunt.hcl
}

inputs = {
  categories = {
    "Ambiente" = {
      description = "Ambiente que contem o recurso"
      cardinality = "MULTIPLE"
      types       = [
        "VirtualMachine"
      ]    
    }
    "Aplicacao" = {
      description = "A qual aplicacao se destina"
      cardinality = "MULTIPLE"
      types       = [
        "VirtualMachine"
      ]    
    }
    "Guest_OS" = {
      description = "Qual o sistema operacional"
      cardinality = "MULTIPLE"
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
      description = "Tipo Storage Kubernetes"
      cardinality = "SINGLE"
      types       = [
        "Datacenter",
        "Datastore",
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
    "Origem" = {
      description = "Via codigo ou Manual"
      cardinality = "MULTIPLE"
      types       = [
        "VirtualMachine"
      ]    
    }
    "Rancher" = {
      description = ""
      cardinality = "SINGLE"
      types       = [
        "VirtualMachine"
      ]    
    }
    "Responsavel" = {
      description = "Responsavel pelo recurso"
      cardinality = "MULTIPLE"
      types       = [
        "VirtualMachine"
      ]    
    }
    "Responsável" = {
      description = "Responsável"
      cardinality = "SINGLE"
      types       = [
        "VirtualMachine"
      ]    
    }
    "snapshots_vrops" = {
      description = "Tags referentes a snapshots (prazo, tamanho, etc) para serem usadas nas automações do vrops."
      cardinality = "SINGLE"
      types       = [
        "VirtualMachine"
      ]    
    }
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
    "vSANDirectStorage" = {
      description = ""
      cardinality = "MULTIPLE"
      types       = [
        "Datastore"
      ]    
    }
  }   
}


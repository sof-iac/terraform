terraform {
  source = "../../../../modules/vsphere/datacenter-config"
}

include {
  path = find_in_parent_folders()
}

inputs = {
  datacenter = {
    dc-name = "SOF"
    tags    = ["urn:vmomi:InventoryServiceTag:7cc018fa-7303-4ade-88f8-50047a7ba0ba:GLOBAL"] 
  }
  
  attributes = {
    "NB_LAST_BACKUP" = {
      object-type = "VirtualMachine"
    }
  }

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

  tags = {  
    "dev" = {
      description = ""
      category    = "Ambiente"
    }
    "Teste" = {
      description = "Ambiente dos recursos de Teste"
      category    = "Ambiente"
    }
    "Lab" = {
      description = "Ambiente dos recursos de Laboratorio"
      category    = "Ambiente"
    }
    "Prod" = {
      description = "Ambiente dos recursos de Producao"
      category    = "Ambiente"
    }
    "ELK" = {
      description = "Pilha Elastic"
      category    = "Aplicacao"
    }
    "Mariadb" = {
      description = "Banco de dados MariaDB"
      category    = "Aplicacao"
    }
    "kubernetes" = {
      description = ""
      category    = "Aplicacao"
    }
    "Postgres" = {
      description = "Banco de dados Postgres"
      category    = "Aplicacao"
    }
    "repositorio" = {
      description = "Repositorios Ubuntu"
      category    = "Aplicacao"
    }
    "ALM" = {
      description = "Application lifecycle management"
      category    = "Aplicacao"
    }
    "Jazz" = {
      description = "Jazz - Ciclo de Vida Desenvolvimento"
      category    = "Aplicacao"
    }
    "Jenkins" = {
      description = "Servidores do Jenkins"
      category    = "Aplicacao"
    }
    "NetBackup" = {
      description = "Servidores relacionados ao NetBackup"
      category    = "Aplicacao"
    }
    "Sofex" = {
      description = "Servidores relacionados ao extrator de eventos das máquinas Windows"
      category    = "Aplicacao"
    }
    "k8s_region_SOF" = {
      description = ""
      category    = "k8s_region"
    }
    "k8s_storage_platinum" = {
      description = ""
      category    = "k8s_storage"
    }
    "k8s_storage_all" = {
      description = ""
      category    = "k8s_storage"
    }
    "k8s_storage_lab" = {
      description = ""
      category    = "k8s_storage"
    }
    "k8s_storage_silver" = {
      description = ""
      category    = "k8s_storage"
    }
    "k8s_storage_minio" = {
      description = ""
      category    = "k8s_storage"
    }
    "k8s_storage_blocok" = {
      description = ""
      category    = "k8s_storage"
    }
    "k8s_storage_gold" = {
      description = ""
      category    = "k8s_storage"
    }
    "k8s_zone_SOF" = {
      description = ""
      category    = "k8s_zone"
    }
    "ansible" = {
      description = "Recurso criados via Ansible"
      category    = "Origem"
    }
    "Terraform" = {
      description = "Recurso criados via Terraform"
      category    = "Origem"
    }
    "alexislab2" = {
      description = "Tag para o cluster alexislab2"
      category    = "Rancher"
    }
    "available" = {
      description = "VM disponivel para um cluster"
      category    = "Rancher"
    }
    "Rogerio_Vieira_Silva" = {
      description = "Responsável pela criacao"
      category    = "Responsavel"
    }
    "Joao_Francisco" = {
      description = "Responsável pela criacao"
      category    = "Responsavel"
    }
    "CODIN" = {
      description = ""
      category    = "Responsável"
    }
    "snapshots_10_dias" = {
      description = "Tag para VM poder ficar com snapshot por até 10 dias."
      category    = "snapshots_vrops"
    }
    "Sof-Vshere-Ubuntu" = {
      description = "Sof-Vshere-Ubuntu"
      category    = "VM-SOF"
    }
  }   

  folders ={
    
  }
}


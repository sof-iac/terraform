variable vm {
  type = map(object(
    {
      datacenter        = string
      datastore_cluster = string
      resource_pool     = string
      vmname            = string
      template          = string
      instances         = number
      vmstartcount      = number
      cpu               = number
      memory            = number
      local_adminpass   = string    
      network           = map(list(string))
      network_type      = list(string)
      domain            = string  
      dns_server_list   = list(string)
      vsphere_cluster   = string      
      mask              = list(string)
      gateway           = string
      annotation        = string
      tags              = map(any)
      data_disk         = map(map(any))
      scsi_bus_sharing  = string
      scsi_type         = string
      scsi_controller   = number
      enable_disk_uuid  = bool
      # Parametros da Organizacao
      orgname           = string
      workgroup         = string
      is_windows_image  = bool
      firmware          = string

    })
  )
}
variable vm {
  type = map(object(
    {
      template          = string
      instances         = number
      vmstartcount      = number
      staticvmname      = string
      datacenter        = string
      datastore_cluster = string
      vsphere_cluster   = string
      resource_pool     = string
      domain            = string
      network           = map(list(string))
      local_adminpass   = string
      mask              = list(string)
      gateway           = string
      data_disk         = map(map(any))
      cpu               = number
      memory            = number
      network_type      = list(string)
      annotation        = string
      tags              = map(any)
      distro            = string
    })
  )
}
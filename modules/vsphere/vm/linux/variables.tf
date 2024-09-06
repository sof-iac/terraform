variable vm {
  type = map(object(
    {
      template          = string
      instances         = number
      datacenter        = string
      datastore_cluster = string
      vsphere_cluster   = string
      resource_pool     = string
      network           = map(list(string))
      mask              = list(string)
      gateway           = string
      data_disk         = map(map(any))
      cpu               = number
      memory            = number
      network_type      = string
    })
  )
}
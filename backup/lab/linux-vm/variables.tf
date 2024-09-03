variable vm {
  type = map(object(
    {
      template          = string
      instances         = number
      datacenter        = string
      datastore-cluster = string
      resource-pool     = string
      network           = map(list(string))
      mask              = list(string)
      gateway           = string
      # data-disk         = map(map(any))
      cpu               = number
      memory            = number
    })
  )
}
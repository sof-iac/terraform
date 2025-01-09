variable host {
  type = map(object(
    {
      username         = optional(string)
      password         = optional(string)
      license          = optional(string)
      thumbprint       = optional(string)
      cluster-managed  = bool
      datacenter-id    = optional(string)
      maintenance      = optional(bool)

      services = optional(object(
        {
          enabled     = bool
          policy      = string
          ntp-servers = list(string)
        })
      )
    })
  )
}

variable compute-cluster {
  type = map(object(
    {
      datacenter-id = string
      folder        = optional(string)
      hosts         = list(string)
      drs           = object(
        {
          enabled          = bool
          automation-level = string
          advanced-options = optional(map(string))
        }
      )
      dpm           = object(
        {
          enabled          = bool
          automation-level = string
        }
      )
      ha            = object(
        {
          enabled                       = bool
          datastore-apd-recovery-action = optional(string)
          datastore-apd-response        = optional(string)
          datastore-apd-response-delay  = optional(number)
          datastore-pdl-response        = optional(string)
          vm-maximum-failure-window     = optional(number)
          advanced-options              = optional(map(string))
        }
      )
      tags          = optional(set(string))
    })
  )
}

variable resource-pool {
  type = map(object(
    {
      compute-cluster          = string
      cpu-share-level          = optional(string)
      memory-share-level       = optional(string)
      scale-descendants-shares = optional(string)
    })
  )
}
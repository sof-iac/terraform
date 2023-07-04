variable datacenter {
  type = object(
    {
      dc-name = string
      tags    = set(string)
    }
  )
}

variable datastore-cluster {
  type = map(object(
    {
      sdrs = object(
        {
          enabled                        = bool
          automation-level               = string
          free-space-utilization-diff    = number
          io-balance-automation-level    = string
          io-latency-threshold           = number
          io-load-imbalance-threshold    = number
          load-balance-interval          = number
          space-balance-automation-level = string
          space-utilization-threshold    = number
        }
      )
      tags = set(string)
    })
  )
}

variable compute-cluster {
  type = map(object(
    {
      folder   = optional(string)
      host-ids = list(string)
      drs      = object(
        {
          enabled          = bool
          automation-level = string
          advanced-options = optional(map(string))
        }
      )
      dpm     = object(
        {
          enabled          = bool
          automation-level = string
        }
      )
      ha      = object(
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
      tags    = optional(set(string))
    })
  )
}

variable resource-pool {
  type = map(object(
    {
      cluster-name       = string
      cpu-share-level    = optional(string)
      memory-share-level = optional(string)
    })
  )
}
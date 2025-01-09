variable datastore {
  type = map(object(
    {
      folder  = optional(string)
      host-id = string
      disks   = set(string)
      tags    = optional(set(string))
    })
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
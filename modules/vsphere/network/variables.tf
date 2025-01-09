variable vds {
  type = map(object(
    {
      datacenter                       = string
      ignore-other-pvlan-mappings      = bool
      netflow-sampling-rate            = number
      network-resource-control-enabled = bool
      tags                             = set(string)
      hosts                            = set(object(
        {
          host-id = string
          devices = set(string)
        }
      ))
    })
  )
}

variable pg {
  type = map(object(
    {
      vds                             = string
      vlan-id                         = optional(number)
      vlan-range                      = optional(set(object(
        {
          min-vlan = number
          max-vlan = number
        }
      )))
      auto-expand                     = optional(bool)
      block-override-allowed          = optional(bool)
      network-resource-pool-key       = optional(number)
      port-config-reset-at-disconnect = optional(bool)
    })
  )
}
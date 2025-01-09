variable datacenter {
  type = object(
    {
      dc-name = string
      tags    = set(string)
    }
  )
}

variable attributes {
  type = map(object(
    {
      object-type = optional(string)
    })
  )
}

variable categories {
  type = map(object(
    {
      description = string
      cardinality = string
      types       = list(string)
    })
  )
}

variable tags {
  type = map(object(
    {
      description = string
      category    = string
    })
  )
}

variable folders {
  type = map(object(
    {
      type       = string
    })
  )
}
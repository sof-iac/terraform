variable org-unit {
  type = map(object(
    {
     path        = optional(string)
     description = optional(string)
     protected   = optional(bool)
    })
  )
}
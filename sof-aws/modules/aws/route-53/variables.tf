variable zone {
  type = object(
    {
      name    = string
      private = bool
      vpc     = optional(object({
        vpc_id = optional(string)
      })) # No caso de uma zona pública (private = false), não é necessário setar a variável vpc
      env     = string
    }
  )
}

variable records {
  type = list(object(
    {
      name    = string
      type    = string
      ttl     = number
      records = list(string)
    })
  )
}
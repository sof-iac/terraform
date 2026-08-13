variable "category" {
  type = map(object({
    category_name        = string
    category_description = string
    cardinality          = optional(string, "MULTIPLE")
    associable_types     = optional(list(string), ["VirtualMachine"])
  }))
}

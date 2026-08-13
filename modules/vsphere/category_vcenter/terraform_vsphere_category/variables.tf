variable "category_name" {
  description = "Nome da categoria da tag"
  type        = string
}

variable "category_description" {
  description = "Descrição da categoria da tag"
  type        = string
  default     = ""
}

variable "cardinality" {
  description = "SINGLE ou MULTIPLE"
  type        = string
  default     = "MULTIPLE"
}

variable "associable_types" {
  description = "Tipos de objeto aos quais as tags desta categoria podem ser aplicadas"
  type        = list(string)
  default     = ["VirtualMachine"]
}

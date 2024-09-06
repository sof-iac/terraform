    variable "category_name" {
      description = "Nome da categoria da tag"
      type        = string
    }

    variable "category_description" {
      description = "Descrição da categoria da tag"
      type        = string
      default     = ""
    }
    
    variable "tag_name" {
      description = "Nome da tag a ser criada"
      type        = string
    }
    
    variable "tag_description" {
      description = "Descrição da tag"
      type        = string
      default     = ""
    }



    # Módulo Terraform para Criar Tags no vCenter no vSphere 8

    Este módulo permite criar tags no vCenter usando o Terraform.

    ## Estrutura do Módulo

    ```hcl
    variable "tag_name" {
      description = "Nome da tag a ser criada"
      type        = string
    }

    variable "category_name" {
      description = "Nome da categoria da tag"
      type        = string
    }

    variable "category_description" {
      description = "Descrição da categoria da tag"
      type        = string
      default     = ""
    }

    variable "tag_description" {
      description = "Descrição da tag"
      type        = string
      default     = ""
    }

    resource "vsphere_tag_category" "category" {
      name        = var.category_name
      description = var.category_description
      cardinality = "SINGLE"
      associable_types = ["VirtualMachine"]
    }

    resource "vsphere_tag" "tag" {
      name        = var.tag_name
      description = var.tag_description
      category_id = vsphere_tag_category.category.id
    }

    output "tag_id" {
      value = vsphere_tag.tag.id
    }
    ```

    ## Uso do Módulo

    Para usar este módulo, você pode incluí-lo em seu arquivo Terraform principal da seguinte forma:

    ```hcl
    module "my_tag" {
      source              = "./caminho/para/o/modulo"
      tag_name            = "MinhaTag"
      category_name       = "MinhaCategoria"
      category_description = "Descrição da minha categoria"
      tag_description      = "Descrição da minha tag"
    }
    ```

    ## Pré-requisitos

    - Certifique-se de ter o provedor `vsphere` configurado em seu projeto Terraform.
    - O vCenter deve estar acessível e você deve ter permissões adequadas para criar tags e categorias.

    ## Conclusão

    Este módulo fornece uma maneira simples de gerenciar tags no vCenter usando o Terraform, facilitando a organização e a categorização de recursos no vSphere.

include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../../../modules/vsphere/tags_vcenter"  # Caminho relativo ao terragrunt.hcl
}

inputs = {
  tag = {
    "Tags_Origem" = {
      category_name        = "Origem"
      category_description = "Origem da criação do recurso"
      tag_name             = "Terraform"
      tag_description      = "Recurso criados via Terraform"
      },
    "Tags_Env_Lab" = {
      category_name        = "Ambiente"
      category_description = "Ambiente que contem o recurso"
      tag_name             = "Lab"
      tag_description      = "Ambiente dos rescurso de Laboratorio"
      },
    "Tags_Env_Testes" = {
      category_name        = "Ambiente"
      category_description = "Ambiente que contem o recurso"
      tag_name             = "Teste"
      tag_description      = "Ambiente dos rescurso de Testes"
      },
    "Tags_Env_Prod" = {
      category_name        = "Ambiente"
      category_description = "Ambiente que contem o recurso"
      tag_name             = "Prod"
      tag_description      = "Ambiente dos rescurso de Producao"
      },      
    "Tags_Aplicacao_Mariadb" = {
      category_name        = "Aplicacao"
      category_description = "Nome da aplicacao"
      tag_name             = "Mariadb"
      tag_description      = "Banco de dados MariaDB"
      },  
    "Tags_Aplicacao_Postgres" = {
      category_name        = "Aplicacao"
      category_description = "Nome da aplicacao"
      tag_name             = "Postgres"
      tag_description      = "Banco de dados Postgres"
      }              
    }   
}


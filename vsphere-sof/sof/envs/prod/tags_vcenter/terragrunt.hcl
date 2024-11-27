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
      tag_name             = "Terraform"
      tag_description      = "Recurso criados via Terraform"
      },
    "Tags_Env_Lab" = {
      category_name        = "Ambiente"
      tag_name             = "Lab"
      tag_description      = "Ambiente dos recursos de Laboratorio"
      },
    "Tags_Env_Testes" = {
      category_name        = "Ambiente"
      tag_name             = "Teste"
      tag_description      = "Ambiente dos recursos de Teste"
      },
    "Tags_Env_Prod" = {
      category_name        = "Ambiente"
      tag_name             = "Prod"
      tag_description      = "Ambiente dos recursos de Producao"
      },      
    "Tags_Aplicacao_Mariadb" = {
      category_name        = "Aplicacao"
      tag_name             = "Mariadb"
      tag_description      = "Banco de dados MariaDB"
      },  
    "Tags_Aplicacao_Postgres" = {
      category_name        = "Aplicacao"
      tag_name             = "Postgres"
      tag_description      = "Banco de dados Postgres"
      },
    "Tags_Aplicacao_Jenkins" = {
      category_name        = "Aplicacao"
      tag_name             = "Jenkins"
      tag_description      = "Servidores do Jenkins"
      },   
    "Tags_Aplicacao_repo_ubuntu" = {
      category_name        = "Aplicacao"
      tag_name             = "repositorio"
      tag_description      = "Repositorios Ubuntu"
      },   
    "Tags_proprietario" = {
      category_name        = "Responsavel"
      tag_name             = "Rogerio Vieira Silva"
      tag_description      = "Responsável pela criacao"
      },   
    "Tags_Aplicacao_Elk" = {
      category_name        = "Aplicacao"
      tag_name             = "ELK"
      tag_description      = "Pilha Elastic"
      },
    "Tags_Aplicacao_Jazz" = {
      category_name        = "Aplicacao"
      tag_name             = "Jazz"
      tag_description      = "Jazz - Ciclo de Vida Desenvolvimento"
      },
    "Tags_Aplicacao_ALM" = {
      category_name        = "Aplicacao"
      tag_name             = "ALM"
      tag_description      = "Application lifecycle management"
      }               
    }   
}

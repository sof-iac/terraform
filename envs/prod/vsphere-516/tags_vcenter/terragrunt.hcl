include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../../modules/vsphere/tags_vcenter"  # Caminho relativo ao terragrunt.hcl
}

inputs = {
  tag = {
    "Tags_RVS" = {
      category_name        = "Responsavel"
      tag_name             = "Rogerio Vieira Silva"
      tag_description      = "Owner do objeto/servico"
      },
    "Tags_Sattler" = {
      category_name        = "Responsavel"
      tag_name             = "Nelson Sattler da Fonseca"
      tag_description      = "Owner do objeto/servico"
      },
    "Tags_RT" = {
      category_name        = "Responsavel"
      tag_name             = "Ricardo Tadeu A Peixoto"
      tag_description      = "Owner do objeto/servico"
      },
    "Tags_Rjesus" = {
      category_name        = "Responsavel"
      tag_name             = "Robson Mendes de Jesus"
      tag_description      = "Owner do objeto/servico"
      },
    "Tags_glmiranda" = {
      category_name        = "Responsavel"
      tag_name             = "Gabriel M Lima"
      tag_description      = "Owner do objeto/servico"
      },
    "Tags_jhonfaria" = {
      category_name        = "Responsavel"
      tag_name             = "Jhon Allen M Faria"
      tag_description      = "Owner do objeto/servico"
      },
    "Tags_jcesarbarreto" = {
      category_name        = "Responsavel"
      tag_name             = "Julio Cesar O Barreto"
      tag_description      = "Owner do objeto/servico"
      },
    "Tags_alexismaior" = {
      category_name        = "Responsavel"
      tag_name             = "Alexis B S Maior"
      tag_description      = "Owner do objeto/servico"
      },
    "Tags_Jenkins" = {
      category_name        = "Aplicacao"
      tag_name             = "Jenkins"
      tag_description      = "Jenkins Server"
      },
    "Tags_Apache" = {
      category_name        = "Aplicacao"
      tag_name             = "Apache"
      tag_description      = "Servidor Apache"
      },
    "Tags_Jboss" = {
      category_name        = "Aplicacao"
      tag_name             = "Jboss"
      tag_description      = "Servidor Jboss"
      },
    "Tags_Postgres" = {
      category_name        = "Aplicacao"
      tag_name             = "Postgresql"
      tag_description      = "Bancos de dados Postgresql"
      },
    "Tags_AIOPS" = {
      category_name        = "Aplicacao"
      tag_name             = "AIops"
      tag_description      = "Aiops"
      },
    "Tags_ambientelab" = {
      category_name        = "Ambiente"
      tag_name             = "Lab"
      tag_description      = "Ambiente de Laboratorio"
      },
    "Tags_ambienteTest" = {
      category_name        = "Ambiente"
      tag_name             = "Test"
      tag_description      = "Ambiente de Testes"
      },
    "Tags_k8sportworx" = {
      category_name        = "Aplicacao"
      tag_name             = "k8s_portworx"
      tag_description      = "K8s Portworx"
      }
    }   
}


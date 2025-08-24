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
      tag_name             = "Nelson Sattler"
      tag_description      = "Owner do objeto/servico"
      },
    "Tags_RT" = {
      category_name        = "Responsavel"
      tag_name             = "Ricardo Tadeu"
      tag_description      = "Owner do objeto/servico"
      },
    "Tags_Jenkins" = {
      category_name        = "Aplicacao"
      tag_name             = "Jenkins"
      tag_description      = "Jenkins de Producao"
      },
    "Tags_Postgres" = {
      category_name        = "Aplicacao"
      tag_name             = "Postgresql"
      tag_description      = "Bancos de dados Postgresql"
      }
    }   
}


locals {
  env = "lab" # local.parsed.env
}

# Inputs
inputs = {
  user_svc_passwd = file("secrets.txt")
}

# Gera o arquivo provider.tf com a conexão com o vCenter
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "vsphere" {
  user           = "user_svc_vcenter"
  password       = var.user_svc_passwd
  vsphere_server = "pvcn01.sof.intra"

  # if you have a self-signed cert
  allow_unverified_ssl = true
}
EOF
}

# Armazena o estado no MiniO e usa DynamoDB para bloqueio
remote_state {
  backend = "s3"
  config = {
    bucket                      = "tf-${local.env}"
    key                         = "terraform_lab.tfstate"
    region                      = "us-east-1" # Região fictícia para evitar validações do AWS
    endpoint                    = "https://sof-s3.sof.intra"
    AWS_ACCESS_KEY_ID           = "sof-tf-lab"
    AWS_SECRET_ACCESS_KEY       = "0CtpstM00a3G6PuNXE4PnuEUZ1xDPdjIvqBwM8hM"
    kms_key_id                  = "847b4b54-7fae-412e-aba3-50a3d8527002"
    skip_credentials_validation = true
    skip_requesting_account_id  = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    use_path_style              = true
    dynamodb_endpoint           = "https://dynamodb.sof.intra"
    dynamodb_table              = "sof-ts-prod"  # Nome da tabela DynamoDB para bloqueio
  }
}

# Gera o arquivo backend.tf para o Terraform
generate "backend" {
  path      = "backend.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
terraform {
  backend "s3" {}
}
EOF
}


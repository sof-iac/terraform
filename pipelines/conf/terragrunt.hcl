locals {
  # Lógica simples apenas para definir o HOST, já que user/pass vem via ENV
  module_name  = get_terragrunt_dir()
  # Se o nome do diretorio tiver "516", usa o host do 516, senão usa o K
  vcenter_host = strcontains(local.module_name, "vsphere-516") ? "hostname-do-vcenter-516.intra" : "hostname-do-vcenter-k.intra"
  # Backend S3/MinIO: bucket SEM barras (ex: tf-test), path completo na key
  path_rel     = path_relative_to_include()
  backend_env  = split("/", local.path_rel)[0]  # ex: "test", "prod"
}

# Gera o provider.tf
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "vsphere" {
  # NÃO defina user/password aqui. O Terraform lerá VSPHERE_USER e VSPHERE_PASSWORD do ambiente.
  vsphere_server       = "${local.vcenter_host}"
  allow_unverified_ssl = true
}
EOF
}

# Gera o backend.tf
generate "backend" {
  path      = "backend.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
terraform {
  backend "s3" {
    bucket                      = "tf-${local.backend_env}"
    endpoints                   = { s3 = "https://sof-s3.sof.intra" }
    key                         = "${local.path_rel}/terraform.tfstate"
    
    # NÃO defina access_key/secret_key aqui. O Terraform lerá AWS_ACCESS_KEY_ID e AWS_SECRET_ACCESS_KEY.
    
    region                      = "us-east-1"
    skip_credentials_validation = true
    skip_requesting_account_id  = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    use_path_style              = true
    use_lockfile                = true
  }
}
EOF
}
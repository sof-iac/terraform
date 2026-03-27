locals {
  # Host do vCenter: vem de VSPHERE_SERVER (export no Jenkins). Fallback só se não setado.
  module_name  = get_terragrunt_dir()
  vcenter_host = get_env("VSPHERE_SERVER", strcontains(local.module_name, "vsphere-516") ? "hostname-do-vcenter-516.intra" : "hostname-do-vcenter-k.intra")
  # Backend PostgreSQL (mesmo padrão que envs/terragrunt.hcl — TF_VAR_* injetados no Jenkins)
  backend-pg-user   = get_env("TF_VAR_backend_pg_user")
  backend-pg-passwd = get_env("TF_VAR_backend_pg_passwd")
  backend-pg-host   = "psbd02.sof.intra"
  backend-pg-port   = 5432
  backend-pg-dbname = "terraform"
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
  backend "pg" {
    conn_str    = "postgres://${local.backend-pg-user}:${local.backend-pg-passwd}@${local.backend-pg-host}:${local.backend-pg-port}/${local.backend-pg-dbname}?sslmode=disable"
    schema_name = "terraform_${path_relative_to_include()}"
  }
}
EOF
}

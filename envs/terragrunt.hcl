locals {
  parsed            = regex(".*/envs/(?P<env>.*?)/.*", get_terragrunt_dir())
  env               = local.parsed.env
  module-name       = get_terragrunt_dir()
  vcenter-host      = get_env("VSPHERE_SERVER", strcontains(local.module-name, "vsphere-516") ? get_env("TF_VAR_hostname_vcenter_516", "") : get_env("TF_VAR_hostname_vcenter_k", ""))
  backend-pg-user   = get_env("TF_VAR_backend_pg_user")
  backend-pg-passwd = get_env("TF_VAR_backend_pg_passwd")
  backend-pg-host   = "psbd02.sof.intra"
  backend-pg-port   = 5432
  backend-pg-dbname = "terraform"
}

# Atributo que bloqueia a destruição deste módulo específico
prevent_destroy = true

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF

%{if strcontains(local.module-name, "vsphere")}
# user e password: VSPHERE_USER e VSPHERE_PASSWORD (Jenkins exporta após withCredentials)
provider "vsphere" {
  vsphere_server       = "${local.vcenter-host}"
  allow_unverified_ssl = true
}
%{endif}
EOF
}

generate "backend" {
  path = "backend.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
  terraform {
    backend "pg" {
      conn_str    = "postgres://${local.backend-pg-user}:${local.backend-pg-passwd}@${local.backend-pg-host}:${local.backend-pg-port}/${local.backend-pg-dbname}?sslmode=disable"
      schema_name = "terraform_${path_relative_to_include()}" 
    }
  }
  EOF
}
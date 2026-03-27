locals {
  parsed            = regex(".*/envs/(?P<env>.*?)/.*", get_terragrunt_dir())
  env               = local.parsed.env
  module-name       = get_terragrunt_dir()
  vcenter-host      = strcontains(local.module-name, "vsphere-516") == true ? get_env("TF_VAR_hostname_vcenter_516") : get_env("TF_VAR_hostname_vcenter_k")
  vcenter-user      = strcontains(local.module-name, "vsphere-516") == true ? get_env("TF_VAR_username_vcenter_516") : get_env("TF_VAR_username_vcenter_k")
  vcenter-pass      = strcontains(local.module-name, "vsphere-516") == true ? get_env("TF_VAR_password_vcenter_516") : get_env("TF_VAR_password_vcenter_k")
  backend-pg-user   = get_env("TF_VAR_backend_pg_user")
  backend-pg-passwd = get_env("TF_VAR_backend_pg_passwd")
  backend-pg-host   = "psbd02.sof.intra"
  backend-pg-port   = 5432
  backend-pg-dbname = "terraform"
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF

%{if strcontains(local.module-name, "vsphere")}
provider "vsphere" {
  user           = "${local.vcenter-user}"
  password       = "${local.vcenter-pass}"
  vsphere_server = "${local.vcenter-host}"

  # if you have a self-signed cert
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
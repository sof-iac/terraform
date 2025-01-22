locals {
  parsed             = regex(".*/envs/(?P<env>.*?)/.*", get_terragrunt_dir())
  env                = local.parsed.env
  module-name        = get_terragrunt_dir()
  vcenter-host       = strcontains(local.module-name, "vsphere-516") == true ? get_env("TF_VAR_hostname_vcenter_516") : get_env("TF_VAR_hostname_vcenter_k")
  vcenter-user       = strcontains(local.module-name, "vsphere-516") == true ? get_env("TF_VAR_username_vcenter_516") : get_env("TF_VAR_username_vcenter_k")  
  vcenter-pass       = strcontains(local.module-name, "vsphere-516") == true ? get_env("TF_VAR_password_vcenter_516") : get_env("TF_VAR_password_vcenter_k")
  backend-access-key = get_env("TF_VAR_backend_access_key_${local.env}")
  backend-secret-key = get_env("TF_VAR_backend_secret_key_${local.env}")     
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
    backend "s3" {
      bucket    = "tf-${local.env}"
      endpoints = {
        s3 = "https://sof-s3.sof.intra"   # Minio endpoint
        dynamodb = "https://dynamodb.sof.intra"
      }
      key            = "${path_relative_to_include()}/terraform.tfstate"
      access_key     = "${local.backend-access-key}"
      secret_key     = "${local.backend-secret-key}"
      region         = "us-east-1"
      skip_credentials_validation = true  # Skip AWS related checks and validations
      skip_requesting_account_id = true
      skip_metadata_api_check = true
      skip_region_validation = true
      use_path_style = true             # Enable path-style S3 URLs

      dynamodb_table = "sof-tfstate-${local.env}"
      }
    }
  EOF
}
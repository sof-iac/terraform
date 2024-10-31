locals {
  env    = "prod"
  ad-hostname = get_env("TF_VAR_hostname_ad_k") 
  ad-username = get_env("TF_VAR_username_ad_k") 
  ad-password = get_env("TF_VAR_passwd_ad_k") 
  hostname_vcenter = get_env("TF_VAR_hostname_vcenter_k")
  username_vcenter = get_env("TF_VAR_username_vcenter_k")  
  passwd_vcenter   = get_env("TF_VAR_passwd_vcenter_k")  
  backend_access_key   = get_env("TF_VAR_backend_access_key_prod")
  backend_secret_key   = get_env("TF_VAR_backend_secret_key_prod")     
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "vsphere" {
  user           = "${local.username_vcenter}"
  password       = "${local.passwd_vcenter}"
  vsphere_server = "${local.hostname_vcenter}"

  # if you have a self-signed cert
  allow_unverified_ssl = true
}

provider "ad" {
  winrm_hostname = "${local.ad-hostname}"
  winrm_username = "${local.ad-username}"
  winrm_password = "${local.ad-password}"
  winrm_port     = 5985
  winrm_proto    = "http"
  winrm_insecure = true
  krb_realm      = "BLOCOK.SOF.REMOTO"
}
EOF
}

# Configure S3 as a backend
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
      key            = "${path_relative_to_include()}/terraform_prod.tfstate"
      access_key     = "${local.backend_access_key}"
      secret_key     = "${local.backend_secret_key}"
      region         = "us-east-1"
      skip_credentials_validation = true  # Skip AWS related checks and validations
      skip_requesting_account_id = true
      skip_metadata_api_check = true
      skip_region_validation = true
      use_path_style = true             # Enable path-style S3 URLs

      dynamodb_table = "sof-tfstate-prod"
      }
    }
  EOF
}
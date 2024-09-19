locals {
  env    = "lab" 
  secrets            = jsondecode(file("secrets.json")) 
  bucket_pass        = jsondecode(file("bucket.json"))
  username_vcenter   = local.secrets.username_vcenter  
  passwd_vcenter     = local.secrets.passwd_vcenter 
  backend_access_key = local.bucket_pass.TF_VAR_backend_access_key
  backend_secret_key = local.bucket_pass.TF_VAR_backend_secret_key
}

inputs = {
  minio_pem = "/etc/ssl/certs/minio.pem"
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "vsphere" {
  user           = "${local.username_vcenter}"
  password       = "${local.passwd_vcenter}"
  vsphere_server = "pvcn01.sof.intra"

  # if you have a self-signed cert
  allow_unverified_ssl = true
}
EOF
}
# "${local.backend_secret_key}"
# Configure S3 as a backend
# "${local.backend_access_key}"
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
      key            = "${path_relative_to_include()}/terraform_test.tfstate"
      access_key     = "softflab" 
      secret_key     = "px8YVerl7uFw1Iz1VyszAlh97bfepiXjHJD9XYvr" 
      region         = "us-east-1"
      skip_credentials_validation = true  # Skip AWS related checks and validations
      custom_ca_bundle = "${input.minio_pem}"
      skip_requesting_account_id = true
      skip_metadata_api_check = true
      skip_region_validation = true
      use_path_style = true             # Enable path-style S3 URLs

      dynamodb_table = "sof-tfstate-lab"
      }
    }
  EOF
}



 
locals {
  env    = "test" #local.parsed.env
  secrets         = jsondecode(file("secrets.json"))  
  username_vcenter = local.secrets.username_vcenter  
  passwd_vcenter   = local.secrets.passwd_vcenter 
}
inputs = {
  minio_pem = file("/etc/ssl/certs/minio.pem")
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


# Configure S3 as a backend
generate "backend" {
  path = "backend.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
  terraform {
    backend "s3" {
      bucket    = "tf-${local.env}"
      endpoints = {
        s3 = "http://minio.minio-tenant.svc.cluster.local"   # Minio endpoint
        dynamodb = "http://dynamodb.dynamodb.svc.cluster.local:8000"
      }
      key            = "${path_relative_to_include()}/terraform_test.tfstate"
      access_key     = "softftest"
      secret_key     = "JyruHhEbqQQROEEPIeY6K0sPsB85XinCiL5WypxQ"
      #kms_key_id     = "847b4b54-7fae-412e-aba3-50a3d8527002"
      #custom_ca_bundle = var.minio_pem
      region         = "us-east-1"
      skip_credentials_validation = true  # Skip AWS related checks and validations
      skip_requesting_account_id = true
      skip_metadata_api_check = true
      skip_region_validation = true
      use_path_style = true             # Enable path-style S3 URLs

      dynamodb_table = "sof-tfstate-test"
      }
    }
  EOF
}



 
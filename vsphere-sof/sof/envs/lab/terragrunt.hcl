locals {
  # Parse the file path we're in to read the env name: e.g., env 
  # will be "dev" in the dev folder, "stage" in the stage folder, 
  # etc.
  # parsed = regex(".*\/envs\/(?P<env>.*?)\/.*", get_terragrunt_dir())
  env    = "lab" #local.parsed.enn
}
inputs = {
  passwd_vcenter = file("secrets.txt")
  username_vcenter = "user_svc_vcenter"
  minio_pem = file("minio.pem")
  AWS_ACCESS_KEY_ID = "sof-tf-lab"
  AWS_SECRET_ACCESS_KEY = "0CtpstM00a3G6PuNXE4PnuEUZ1xDPdjIvqBwM8hM"
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "vsphere" {
  user           = "username_vcenter"
  password       =  var.passwd_vcenter
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
      key            = "${path_relative_to_include()}/terraform_lab.tfstate"
      access_key     = "softflab"
      secret_key     = "px8YVerl7uFw1Iz1VyszAlh97bfepiXjHJD9XYvr"
      #kms_key_id     = "847b4b54-7fae-412e-aba3-50a3d8527002"
      # custom_ca_bundle = var.minio_pem
      region         = "us-east-1"
      skip_credentials_validation = true  # Skip AWS related checks and validations
      skip_requesting_account_id = true
      skip_metadata_api_check = true
      skip_region_validation = true
      use_path_style = true             # Enable path-style S3 URLs

      dynamodb_table = "sof-tfstate-lab"
      }
    }
  EOF
}



 
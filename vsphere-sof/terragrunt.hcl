locals {
  # Parse the file path we're in to read the env name: e.g., env 
  # will be "dev" in the dev folder, "stage" in the stage folder, 
  # etc.
  # parsed = regex(".*\/envs\/(?P<env>.*?)\/.*", get_terragrunt_dir())
  env    = "lab" #local.parsed.enn
}
inputs = {
  user_svc_passwd = file("secrets.txt")
  minio_pem = file("minio.pem")
  AWS_ACCESS_KEY_ID = "sof-tf-lab"
  AWS_SECRET_ACCESS_KEY = "0CtpstM00a3G6PuNXE4PnuEUZ1xDPdjIvqBwM8hM"
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "vsphere" {
  user           = "user_svc_vcenter"
  password       =  var.user_svc_passwd
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
        s3 = "https://sof-s3.sof.intra"   # Minio endpoint
        dynamodb = "https://dynamodb.sof.intra"
      }
      key            = "${path_relative_to_include()}/terraform_lab.tfstate"
      access_key     = "FQX1kbkvHXA3QItNcB38"
      secret_key     = "1IEqpzPvUz8LR9kOtJo72oEtyYo4ot28tWHcmfXx"
      #kms_key_id     = "847b4b54-7fae-412e-aba3-50a3d8527002"
      # custom_ca_bundle = var.minio_pem
      region         = "us-east-1"
      skip_credentials_validation = true  # Skip AWS related checks and validations
      skip_requesting_account_id = true
      skip_metadata_api_check = true
      skip_region_validation = true
      use_path_style = true             # Enable path-style S3 URLs

      dynamodb_table = "sof-tf-state-lab"
      }
    }
  EOF
}



 
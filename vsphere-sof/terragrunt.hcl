locals {
  # Parse the file path we're in to read the env name: e.g., env 
  # will be "dev" in the dev folder, "stage" in the stage folder, etc.
  # parsed = regex(".*\/envs\/(?P<env>.*?)\/.*", get_terragrunt_dir())
  env    = "lab" #local.parsed.env
}# Configure S3 as a backend
# Le o arquivo gerado no step anterior que busca a secret do vault
inputs = {
  user_svc_passwd = file("secrets.txt")
}
# gera o arquivo provider.tf com a conexao com o vcenter
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

# Armazena o estado
remote_state {
  backend = "s3"
  config = {
    bucket         = "tf-${local.env}"
    endpoints = {
      s3 = "https://sof-s3.sof.intra"   # Minio endpoint
    }
    key            = "terraform_lab.tfstate"
    access_key     = "sof-tf-lab"
    secret_key     = "0CtpstM00a3G6PuNXE4PnuEUZ1xDPdjIvqBwM8hM"
    kms_key_id     = "847b4b54-7fae-412e-aba3-50a3d8527002"
    region         = "main"
    skip_credentials_validation = true  # Skip AWS related checks and validations
    skip_requesting_account_id = true
    skip_metadata_api_check = true
    skip_region_validation = true
    use_path_style = true             # Enable path-style S3 URLs
    
    dynamodb = "https://dynamodb.sof.intra"
    dynamodb_table = "sof-ts-prod"    
  }
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}


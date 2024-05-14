locals {
  # Parse the file path we're in to read the env name: e.g., env 
  # will be "dev" in the dev folder, "stage" in the stage folder, 
  # etc.
  # parsed = regex(".*\/envs\/(?P<env>.*?)\/.*", get_terragrunt_dir())
  env    = "prod" #local.parsed.env
}# Configure S3 as a backend
remote_state {
  backend = "s3"
  config = {
    bucket         = "sof-iac-${local.env}"
    region         = "sa-east-1"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    kms_key_id     = "847b4b54-7fae-412e-aba3-50a3d8527002"
    dynamodb_table = "state-locking"
  }
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}


    
    
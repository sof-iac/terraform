locals {
  minio_user   = get_env("TF_VAR_minio_username")
  minio_password   = get_env("TF_VAR_minio_password")  
}

include {
  path = find_in_parent_folders()
}


terraform {
  source = "../../../../../../modules/global/minio/buckets"
}

inputs = {
  minio_bucket_names = ["cnpg-sonarqube"]
  minio_acl = "private"
  bucket_policy_create = true
  bucket_policy_action = "s3:*"
  bucket_versioning_enabled = true
}

generate "provider-minio" {
  path      = "provider-minio.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "minio" {
  minio_server       = "sof-s3.sof.intra:443"
  minio_user   = "${local.minio_user}"
  minio_password   = "${local.minio_password}"
  minio_ssl = "true"
}
EOF
}
terraform {
  source = "../../../../modules/minio/buckets"
}

include {
  path = find_in_parent_folders()
}

locals {
  minio-server = "sof-s3.sof.intra:443"
  minio-user   = "minio"
  minio-passwd = get_env("TF_VAR_password_minio")
  minio-ssl    = true
}

generate "provider-minio" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF

provider "minio" {
  minio_server   = "${local.minio-server}"
  minio_user     = "${local.minio-user}"
  minio_password = "${local.minio-passwd}"
  minio_ssl      = "${local.minio-ssl}"
}
EOF
}

inputs = {
  minio_bucket_names = ["cnpg-sonarqube"]
  minio_acl = "private"
  bucket_policy_create = true
  bucket_policy_action = "s3:*"
  bucket_versioning_enabled = true
}
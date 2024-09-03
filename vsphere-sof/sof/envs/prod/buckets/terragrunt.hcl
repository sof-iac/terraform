include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../../../modules/global/minio/buckets"
}

inputs = {
  minio_server = "sof-s3.sof.intra:443"
  minio_user = "minio"
  minio_password = "<replace-me>"
  minio_bucket_names = ["cnpg-sonarqube"]
  minio_acl = "private"
  bucket_policy_create = true
  bucket_policy_action = "s3:*"
  bucket_versioning_enabled = true
}
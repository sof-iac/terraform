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
  minio_bucket_names = ["cnpg-sonarqube","cnpg-sonarqube-additional"]
  minio_acl = "public"
}
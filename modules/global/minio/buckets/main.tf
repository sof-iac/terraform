resource "minio_s3_bucket" "minio_bucket" {
  count = length(var.minio_bucket_names)
  bucket = var.minio_bucket_names[count.index]
  acl    = var.minio_acl
}


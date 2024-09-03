resource "minio_s3_bucket" "minio_bucket" {
  count = length(var.minio_bucket_names)
  bucket = var.minio_bucket_names[count.index]
  acl    = var.minio_acl
}

resource "minio_s3_bucket_policy" "policy" {
  count = var.bucket_policy_create ? length(var.minio_bucket_names) : 0

  depends_on = [minio_s3_bucket.minio_bucket]
  bucket     = minio_s3_bucket.minio_bucket[count.index].bucket
  policy     = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {"AWS": ["*"]},
      "Resource": ["${minio_s3_bucket.minio_bucket[count.index].arn}"],
      "Action": "[${var.bucket_policy_action}]"
    }
  ]
}
EOF
}

resource "minio_s3_bucket_versioning" "bucket" {
  count = var.bucket_versioning_enabled ? length(var.minio_bucket_names) : 0

  depends_on = [minio_s3_bucket.minio_bucket]

  bucket     = minio_s3_bucket.minio_bucket[count.index].bucket

  versioning_configuration {
    status = "Enabled"
  }
}

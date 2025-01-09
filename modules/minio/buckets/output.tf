output "minio_id" {
  value = "${minio_s3_bucket.minio_bucket.*.id}"
}

output "minio_url" {
  value = "${minio_s3_bucket.minio_bucket.*.bucket_domain_name}"
}
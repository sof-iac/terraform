variable "minio_server" {
  type    = string
  default = ""
}

variable "minio_user" {
  type    = string
  default = ""
}

variable "minio_password" {
  type    = string
  default = ""
}

variable "minio_bucket_names" {
  type    = list
  default = [""]
}

variable "minio_acl" {
  type    = string
  default = "private"
}

variable "minio_ssl" {
  type    = string
  default = "true"
}

variable "bucket_versioning_enabled" {
  type    = bool
  default = false
}

variable "bucket_policy_create" {
  type    = bool
  default = false 
}

variable "bucket_policy_action" {
  type    = string
  default = "s3:ListBucket"
}
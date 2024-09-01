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
  default = ""
}
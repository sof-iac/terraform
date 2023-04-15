terraform {
  backend "s3" {
    bucket         = "sof-iac"
    key            = "rede/terraform.tfstate"
    region         = "sa-east-1"
    kms_key_id     = "847b4b54-7fae-412e-aba3-50a3d8527002"
    dynamodb_table = "state-locking"
  }
}
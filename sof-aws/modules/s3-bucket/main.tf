data "aws_canonical_user_id" "current" {}

module "s3_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket = var.bucket.name

  control_object_ownership = true
  object_ownership         = var.bucket.object_ownership

  grant = [{
    type       = "CanonicalUser"
    permission = "FULL_CONTROL"
    id         = data.aws_canonical_user_id.current.id
    }
  ]

  owner = {
    id = data.aws_canonical_user_id.current.id
  }

  versioning = {
    enabled = var.bucket.versioning
  }

  tags = {
    "Name"        = var.bucket.name
    "Environment" = var.bucket.env
    "Terraform"   = "true"
  }
}
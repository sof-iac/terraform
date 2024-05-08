include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../../../modules/aws/s3-bucket"
}
  inputs = {
    bucket = {
      name             = "sof-velero-backup-poc"
      object_ownership = "ObjectWriter"
      versioning       = false
      env              = "sof-aws-prod"
    }   
}
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.61.0"
    }
  }
}
provider "aws" {
  region     = "sa-east-1"
  access_key = ""
  secret_key = ""
}
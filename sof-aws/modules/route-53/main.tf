module "private_zone" {
  source  = "terraform-aws-modules/route53/aws//modules/zones"
  version = "~> 2.0"

  count = var.zone.private ? 1 : 0

  zones = {
    (var.zone.name) = {
      comment = "Managed by Terraform"

      vpc = var.zone.vpc

      tags = {
        "Name"        = var.zone.name
        "Environment" = var.zone.env
        "Type"        = var.zone.private ? "private.domain" : "public.domain"
        "Terraform"   = "true"
      }
    }
  }
}

module "public_zone" {
  source  = "terraform-aws-modules/route53/aws//modules/zones"
  version = "~> 2.0"

  count = var.zone.private ? 0 : 1

  zones = {
    (var.zone.name) = {
      comment = "Managed by Terraform"

      tags = {
        "Name"        = var.zone.name
        "Environment" = var.zone.env
        "Type"        = var.zone.private ? "private.domain" : "public.domain"
        "Terraform"   = "true"
      }
    }
  }
}

module "records" {
  source  = "terraform-aws-modules/route53/aws//modules/records"
  version = "~> 2.0"

  count = var.records != null ? 1 : 0

  zone_name = var.zone.name
  private_zone = var.zone.private

  records_jsonencoded = jsonencode(var.records)

  depends_on = [module.private_zone, module.public_zone]
 }
provider "vault" {}

resource "vault_mount" "pki" {
  path        = "secrets/pki_sof_int/sof-intra"
  type        = "pki"
  description = "PKI backend to issue certificates"
}

resource "vault_pki_secret_backend_role" "teste234.sof.intra" {
  backend               = vault_mount.pki.path
  name                  = "my-role"
  allowed_domains       = ["example.com"]
  allow_subdomains      = true
  max_ttl               = "72h"
}

resource "vault_pki_secret_backend_cert" "cert" {
  backend = vault_mount.pki.path
  name    = vault_pki_secret_backend_role.my_role.name
  common_name = "example.com"
  ttl     = "24h"
}

output "certificate" {
  value = vault_pki_secret_backend_cert.cert.certificate
}

output "private_key" {
  value = vault_pki_secret_backend_cert.cert.private_key
}

output "issuing_ca" {
  value = vault_pki_secret_backend_cert.cert.issuing_ca
}
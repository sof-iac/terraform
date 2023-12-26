variable "dns_server" {
  description = "O endereço IP do servidor DNS"
}

variable "dns_zone" {
  description = "O nome da zona DNS"
}

variable "record_name" {
  description = "O nome do registro DNS"
}

variable "record_value" {
  description = "O valor do registro DNS"
}

provider "dns" {
  update {
    server        = var.dns_server
    key_name      = ""
    key_algorithm = "hmac-md5"
    key_secret    = ""
  }
}

data "dns_a_record_set" "example" {
  host = "${var.record_name}.${var.dns_zone}"
}

resource "dns_a_record_set" "example" {
  count = data.dns_a_record_set.example.addrs[0] != var.record_value ? 1 : 0

  zone = var.dns_zone
  name = var.record_name
  addresses = [var.record_value]
  ttl = 300
}

terraform {
  required_version = "~> 1.8"

  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.42"
    }
  }
}

provider "cloudflare" {
  api_token = var.api_token
}

data "cloudflare_zone" "this" {
  name = var.zone_name
}

# This is necessary to allow Let's Encrypt to issue certificates.
resource "cloudflare_record" "letsencrypt" {
  zone_id = data.cloudflare_zone.this.id
  name    = "@"
  type    = "CAA"

  data {
    flags = 128
    tag   = "issue"
    value = "letsencrypt.org"
  }
}

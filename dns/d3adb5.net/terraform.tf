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

# Extra CNAME records to create.
resource "cloudflare_record" "extra_cnames" {
  for_each = var.extra_cnames
  zone_id  = data.cloudflare_zone.this.id
  name     = each.key
  type     = "CNAME"
  content  = each.value
}

# Dynamic IP address record for the homelab.
resource "cloudflare_record" "dynamic" {
  zone_id = data.cloudflare_zone.this.id
  name    = "home"
  type    = "A"
  content = "127.0.0.1"

  lifecycle {
    ignore_changes = [content]
  }
}

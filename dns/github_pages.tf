locals {
  github_pages_ipv4 = [
    "185.199.108.153",
    "185.199.109.153",
    "185.199.110.153",
    "185.199.111.153",
  ]

  github_pages_ipv6 = [
    "2606:50c0:8000:0:0:0:0:153",
    "2606:50c0:8001:0:0:0:0:153",
    "2606:50c0:8002:0:0:0:0:153",
    "2606:50c0:8003:0:0:0:0:153",
  ]
}

resource "cloudflare_record" "github_pages_ipv4" {
  for_each = toset(local.github_pages_ipv4)
  zone_id  = data.cloudflare_zone.this.id
  name     = "@"
  type     = "A"
  content  = each.key
}

resource "cloudflare_record" "github_pages_ipv4_charts" {
  for_each = toset(local.github_pages_ipv4)
  zone_id  = data.cloudflare_zone.this.id
  name     = "charts"
  type     = "A"
  content  = each.key
}

resource "cloudflare_record" "github_pages_ipv6" {
  for_each = toset(local.github_pages_ipv6)
  zone_id  = data.cloudflare_zone.this.id
  name     = "@"
  type     = "AAAA"
  content  = each.key
}

resource "cloudflare_record" "github_pages_ipv6_charts" {
  for_each = toset(local.github_pages_ipv6)
  zone_id  = data.cloudflare_zone.this.id
  name     = "charts"
  type     = "AAAA"
  content  = each.key
}

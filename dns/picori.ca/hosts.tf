locals {
  hostmap_ipv4 = { for h, a in var.hosts : h => a.ipv4 }
  hostmap_ipv6 = { for h, a in var.hosts : h => a.ipv6 if a.ipv6 != null }
}

resource "cloudflare_record" "hosts_ipv4" {
  for_each = local.hostmap_ipv4
  zone_id  = data.cloudflare_zone.this.id
  name     = each.key
  type     = "A"
  content  = each.value
}

resource "cloudflare_record" "hosts_ipv6" {
  for_each = local.hostmap_ipv6
  zone_id  = data.cloudflare_zone.this.id
  name     = each.key
  type     = "AAAA"
  content  = each.value
}

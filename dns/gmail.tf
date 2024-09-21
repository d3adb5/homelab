locals {
  dkim_pubkey = join("", [
    "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAkH8Vp6nBg2+Ohe7X+uf9PwiteUUsO",
    "+N+fhPjZjeI67wkkt4EytmUKxUgdln/+1HzHmlUFNjMJniGJCfK83UpXzdfRlQvic0sBtKiuj",
    "gi+sqJAhMyjT2yegfUBhnN7HLoW68o5TUKVg2Ph6FKy72LZ4YoQjeVqxioGVpv9yOaLVyhAmW",
    "ocTkH319AjlKvFPWqMbIs6fGuy69DqI4yUCUZT8NlX9eynyF8sD0MAuXEKRKlY0ToWmYO+9BS",
    "xGHy7eHZK0WVWNh4uC17IairoEkHXZ0DQH97UeL2b5zPtVWdSvqe+Jc7opwvECV9l5YURXgc7",
    "2ZvSkg6JWbrzPNO8ZxhcQIDAQAB"
  ])
}

resource "cloudflare_record" "google_domainkey" {
  zone_id = data.cloudflare_zone.this.id
  name    = "google._domainkey"
  type    = "TXT"
  content = "v=DKIM1; k=rsa; p=${local.dkim_pubkey}"
}

resource "cloudflare_record" "gmail" {
  for_each = {
    "aspmx.l.google.com"      = 1
    "alt1.aspmx.l.google.com" = 5
    "alt2.aspmx.l.google.com" = 5
    "alt3.aspmx.l.google.com" = 10
    "alt4.aspmx.l.google.com" = 10
  }

  zone_id = data.cloudflare_zone.this.id
  name    = "@"
  type    = "MX"

  priority = each.value
  content  = each.key
}

resource "cloudflare_record" "spf" {
  zone_id = data.cloudflare_zone.this.id
  name    = "@"
  type    = "TXT"
  content = "v=spf1 include:_spf.google.com ~all"
}

# Domain verification for Google Workspace.
resource "cloudflare_record" "google_cname" {
  zone_id = data.cloudflare_zone.this.id
  name    = "cg3vgswa6ehx"
  type    = "CNAME"
  content = "gv-mng22fgtuvkl6z.dv.googlehosted.com"
}

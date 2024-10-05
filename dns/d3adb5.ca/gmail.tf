locals {
  dkim_pubkey = join("", [
    "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAyYTu42yDiKaC01TF0Xjenh0Vpmfiu",
    "vWpCIp41eeJw7o24p//3YOwRQLL7ZZ70hCCdXpUjl4ZLqWiXn41wsHynoMiI0tBV4cLbt2jF7",
    "07EZY1uVByQq6kjX0luzJXlaH5mtxpI2oryhrAVxnsowXqxI/pyGH70+zHrvUVCLf6nqg2UR3",
    "yR4or83/CFtMsejTAkgvL+1o4i9FyXhgi/fulpSFMlxiS9VDfzgpTduiOM5JNcysDcnl+p3ya",
    "drkNnMuEHJzlkyP2HFbXkl7+xIC09A78YEfFKNnMNb7jfI84aUK570zTaeNK0BDDrPqq7+foG",
    "KEeXREbpLThTldyRpq92QIDAQAB"
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
  name    = "egux7cpqygpj"
  type    = "CNAME"
  content = "gv-cz7sahvemw7nwq.dv.googlehosted.com"
}

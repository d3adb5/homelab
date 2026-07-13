resource "cloudflare_record" "ses_dkim" {
  for_each = toset(var.ses_dkim_tokens)

  zone_id = data.cloudflare_zone.this.id
  name    = "${each.value}._domainkey"
  type    = "CNAME"
  content = "${each.value}.dkim.amazonses.com"
}

resource "cloudflare_record" "ses_mail_from_mx" {
  zone_id  = data.cloudflare_zone.this.id
  name     = "ses"
  type     = "MX"
  priority = 10
  content  = var.aws_ses_mail_from_mx
}

resource "cloudflare_record" "ses_mail_from_spf" {
  zone_id = data.cloudflare_zone.this.id
  name    = "ses"
  type    = "TXT"
  content = "v=spf1 include:amazonses.com -all"
}

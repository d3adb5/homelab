output "dkim_tokens" {
  description = "DKIM tokens: <token>._domainkey CNAME -> <token>.dkim.amazonses.com."
  value       = aws_sesv2_email_identity.domain.dkim_signing_attributes[0].tokens
}

output "mail_from_domain" {
  description = "Custom MAIL FROM domain that needs MX and SPF records."
  value       = aws_sesv2_email_identity_mail_from_attributes.domain.mail_from_domain
}

output "mail_from_mx" {
  description = "Target for the MX record on the custom MAIL FROM subdomain."
  value       = "feedback-smtp.${var.aws_region}.amazonses.com"
}

output "smtp_host" {
  description = "SES SMTP endpoint for this region."
  value       = "email-smtp.${var.aws_region}.amazonaws.com"
}

output "smtp_credentials" {
  description = "SMTP username and password for each entry in smtp_users."
  sensitive   = true

  value = {
    for name, key in aws_iam_access_key.smtp : name => {
      username = key.id
      password = key.ses_smtp_password_v4
    }
  }
}

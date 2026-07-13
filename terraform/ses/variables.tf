variable "aws_region" {
  type        = string
  description = "AWS region to use."
}

variable "domain" {
  type        = string
  description = "Domain to verify with SES and send email from."
}

variable "verified_recipients" {
  type    = list(string)
  default = []

  description = "Addresses verified individually for the SES sandbox."
}

variable "smtp_users" {
  type    = map(object({ from_addresses = optional(list(string)) }))
  default = {}

  description = "SMTP credentials to create, one per service."
}

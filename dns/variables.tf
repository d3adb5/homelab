variable "api_token" {
  description = "Cloudflare API token used to edit DNS records"
  type        = string
  sensitive   = true
}

variable "zone_name" {
  description = "Name of the DNS zone to manage"
  type        = string
}

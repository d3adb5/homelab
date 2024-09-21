variable "api_token" {
  description = "Cloudflare API token used to edit DNS records"
  type        = string
  sensitive   = true
}

variable "zone_name" {
  description = "Name of the DNS zone to manage"
  type        = string
}

variable "hosts" {
  description = "Map of hosts to create subdomain records for"

  type = map(object({
    ipv4 = string
    ipv6 = optional(string)
  }))
}

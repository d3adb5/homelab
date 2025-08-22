variable "client_id" {
  description = "Client ID for the Keycloak client used by Terraform."
  type        = string
  sensitive   = true
}

variable "client_secret" {
  description = "Client secret for the Keycloak client used by Terraform."
  type        = string
  sensitive   = true
}

variable "keycloak_url" {
  description = "URL for the Keycloak server."
  type        = string
}

variable "users" {
  description = "Map of users to create in our main realm, indexed by username."

  type = map(object({
    enabled          = optional(bool, true)
    email            = string
    initial_password = optional(string)
    first_name       = optional(string)
    last_name        = optional(string)
    groups           = optional(list(string), [])
  }))
}

variable "clients" {
  description = "OIDC clients to be provisioned through this module."
  default     = {}

  type = map(object({
    name     = string
    enabled  = optional(bool, true)
    root_url = string

    web_origins                     = optional(list(string))
    valid_redirect_uris             = list(string)
    valid_post_logout_redirect_uris = optional(list(string), ["+"])
  }))
}

variable "groups" {
  description = "Top level groups to be created in the main realm."
  default     = []
  type        = list(string)
}

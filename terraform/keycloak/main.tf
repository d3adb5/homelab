terraform {
  required_version = "~> 1.8"

  required_providers {
    keycloak = {
      source  = "keycloak/keycloak"
      version = "~> 5.4"
    }
  }
}

provider "keycloak" {
  client_id     = var.client_id
  client_secret = var.client_secret
  url           = var.keycloak_url
}

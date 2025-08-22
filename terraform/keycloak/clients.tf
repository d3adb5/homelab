resource "keycloak_openid_client_scope" "groups" {
  realm_id = keycloak_realm.core.id
  name     = "groups"
}

resource "keycloak_openid_group_membership_protocol_mapper" "groups" {
  realm_id        = keycloak_realm.core.id
  claim_name      = "groups"
  name            = "groups"
  client_scope_id = keycloak_openid_client_scope.groups.id
}

resource "keycloak_openid_client" "this" {
  for_each = var.clients

  realm_id  = keycloak_realm.core.id
  client_id = each.key

  name                  = each.value.name
  enabled               = each.value.enabled
  standard_flow_enabled = true

  access_type        = "CONFIDENTIAL"
  use_refresh_tokens = false
  root_url           = each.value.root_url

  web_origins                     = coalesce(each.value.web_origins, [each.value.root_url])
  valid_redirect_uris             = each.value.valid_redirect_uris
  valid_post_logout_redirect_uris = each.value.valid_post_logout_redirect_uris
}

resource "keycloak_openid_client_default_scopes" "this" {
  for_each = keycloak_openid_client.this

  realm_id  = keycloak_realm.core.id
  client_id = each.value.id

  default_scopes = [
    "acr",
    "basic",
    "email",
    "profile",
    "roles",
    "web-origins",
    keycloak_openid_client_scope.groups.name,
  ]
}

resource "keycloak_openid_client_optional_scopes" "this" {
  for_each = keycloak_openid_client.this

  realm_id  = keycloak_realm.core.id
  client_id = each.value.id

  optional_scopes = [
    "address",
    "microprofile-jwt",
    "offline_access",
    "phone",
  ]
}

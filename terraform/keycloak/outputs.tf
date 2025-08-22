output "client_secrets" {
  description = "Client secrets for OIDC clients"
  value       = { for client in keycloak_openid_client.this : client.client_id => client.client_secret }
  sensitive   = true
}

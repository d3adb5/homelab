resource "keycloak_realm" "core" {
  realm   = "core"
  enabled = true

  display_name      = "homelab"
  display_name_html = "<strong>homelab</strong>"

  login_theme = "keycloak"

  default_signature_algorithm = "RS256"

  sso_session_idle_timeout = "2h"

  reset_password_allowed = true

  dynamic "smtp_server" {
    for_each = var.smtp[*]

    content {
      host              = smtp_server.value.host
      port              = smtp_server.value.port
      from              = smtp_server.value.from
      from_display_name = smtp_server.value.from_display_name
      starttls          = true

      auth {
        username = smtp_server.value.username
        password = smtp_server.value.password
      }
    }
  }
}

resource "keycloak_user" "users" {
  for_each = var.users

  realm_id = keycloak_realm.core.id
  username = each.key
  enabled  = each.value.enabled

  email_verified = false

  email      = each.value.email
  first_name = each.value.first_name
  last_name  = each.value.last_name

  dynamic "initial_password" {
    for_each = toset(compact([each.value.initial_password]))
    content {
      temporary = true
      value     = initial_password.value
    }
  }

  lifecycle {
    ignore_changes = [email_verified]
  }
}

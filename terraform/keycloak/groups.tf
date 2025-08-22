resource "keycloak_group" "this" {
  for_each = toset(var.groups)
  realm_id = keycloak_realm.core.id
  name     = each.key
}

resource "keycloak_group_memberships" "this" {
  for_each = local.group_memberships

  realm_id = keycloak_realm.core.id
  group_id = each.value.group_id
  members  = each.value.users

  depends_on = [keycloak_user.users]
}

locals {
  group_memberships = {
    for group in toset(var.groups) : group => {
      group_id = keycloak_group.this[group].id
      users = [
        for username, user in var.users : username if contains(user.groups, group)
      ]
    }
  }
}

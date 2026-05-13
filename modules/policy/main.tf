locals {
  policy_definitions = {
    deny_public_ip = {
      name         = "deny-public-ip"
      display_name = "Deny creation of public IP addresses"
      description  = "Prevents creation of public IP addresses to reduce attack surface"
      file         = "deny-public-ip.json"
      # Bastion and Firewall legitimately require public IPs — exempt networking RG
      not_scopes   = ["/subscriptions/${var.subscription_id}/resourceGroups/rg-networking-asf"]
    }
    deny_http = {
      name         = "deny-http"
      display_name = "Deny HTTP-only web apps"
      description  = "All web apps must use HTTPS only"
      file         = "deny-http.json"
      not_scopes   = []
    }
    require_tags = {
      name         = "require-tags"
      display_name = "Require environment, project and owner tags"
      description  = "All resources must have environment, project, and owner tags"
      file         = "require-tags.json"
      not_scopes   = []
    }
    deny_old_tls = {
      name         = "deny-old-tls"
      display_name = "Deny TLS versions below 1.2"
      description  = "Storage accounts and web apps must use TLS 1.2 or higher"
      file         = "deny-old-tls.json"
      not_scopes   = []
    }
    audit_mfa = {
      name         = "audit-mfa"
      display_name = "Audit user role assignments (MFA posture)"
      description  = "Audits direct user role assignments to track MFA coverage"
      file         = "audit-mfa.json"
      not_scopes   = []
    }
    deny_unencrypted_storage = {
      name         = "deny-unencrypted-storage"
      display_name = "Deny storage accounts without HTTPS enforcement"
      description  = "All storage accounts must enforce HTTPS traffic only"
      file         = "deny-unencrypted-storage.json"
      not_scopes   = []
    }
  }
}

resource "azurerm_policy_definition" "this" {
  for_each = local.policy_definitions

  name         = each.value.name
  display_name = each.value.display_name
  description  = each.value.description

  policy_type = "Custom"
  mode        = "All"

  policy_rule = file("${path.module}/definitions/${each.value.file}")

  metadata = jsonencode({
    category = "Security"
    version  = "1.0.0"
  })
}

resource "azurerm_subscription_policy_assignment" "this" {
  for_each = local.policy_definitions

  name                 = "asf-${each.value.name}"
  display_name         = each.value.display_name
  subscription_id      = "/subscriptions/${var.subscription_id}"
  policy_definition_id = azurerm_policy_definition.this[each.key].id
  not_scopes           = each.value.not_scopes
}
